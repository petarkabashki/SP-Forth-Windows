
\ 14.Apr.2001 
\ ���������� ensemble{}^
\            Ensemble-ForEach
\            Ensamble-Volume
\ * Ensemble-ForEach ��������� �� _���������_ (���� �� ������� ��������)


\ 06.07.2000  ruv

( ���������� �������� ������������ ���������.

  ������� ������� �� ����� [1 CELLS] � �������� [1 CELLS] 
  �������� ���������������� ������.
  �������� �� ��������� �� �����������.

  ��������� ����� ������ [����� ���������] �, ��������, �����.
  ������� ���������
    - � �������:    �����_��������� -- �������������
    - � �������:    ��� �����_��������� --  \ ���:   -- �������������
    - �����������:  �����_��������� -- �������������

  ��������
    ���������� �������� [���� ��������] �� ���������.
    ��������� �������� �� �����.
    ���������� �������� �� ���������  �� �����.
    �������� ����� ��������� � ��������� [?]

  ��������� ����������� � ���� �������������� �� ������ �������.
  ������ ������������ �������� ������� ����� � �������.
  ��� ���������� ��������, ��� ���� ������ ��� �����, ��������� ����������.

  �������� ���������� - ���������� ����� �� ���������.
)

(
    multitude \
               > ?
    ensemble  /       ��������. ?. ;]
)



\ Create-Ensemble  ( n -- ) \ "name"
\ ������� �������� �� n ��������� � ������� �������
\ name ( -- Ens )  - ���� ������������� ���������

\ New-Ensemble  ( n -- Ens ) 
\ ������� �������� �� n ��������� � ����������� �������������� ������.

\ Del-Ensemble ( Ens -- )
\ ������������, ���� ������� �����������.

\ ensemble+   ( value key Ens -- )
\ �������� ������� [key value] � ��������� Ens

\ ensemble-   ( key Ens -- )
\ ��������� �������, ���������������� key �� �������� Ens

\ ensemble{}  ( key Ens -- value true |  key Ens -- false )
\ �������� �������� �� key  �� ��������� Ens
\ value - �������� ��������, ������������������� ������ key (���� �� ���� � ���������)
\ {} - ������� � ���, ��� ������ ���������� �� �����
\ ( ����� [] - ��� ������ �� �������...)


REQUIRE  {        ~ac\lib\locals.f
REQUIRE  InVoc{   ~ac\lib\transl\vocab.f

InVoc{ vocEnsemble

0 
4 -- 'elemcount
4 -- 'elemcountmax
0 --  base
CONSTANT /header

(  4    4
   key  value
)
8 CONSTANT /el

\ Created-Ensemble
\ : Ensemble-Created  ( a-name len-name -- Ens ) 
\ ;

Public{

: Create-Ensemble  ( n -- ) \ "name"
  CREATE  
  HERE >R
  DUP  /el *  /header + DUP ALLOT
  R@ SWAP ERASE
  R> 'elemcountmax !
;

: New-Ensemble  ( n -- Ens ) 
  DUP  /el *  /header + DUP ALLOCATE THROW >R
  R@ SWAP ERASE
  R@ 'elemcountmax !  R>
;
: Del-Ensemble ( Ens -- )
  FREE THROW
;

}Public



: []  ( i a-base -- ai@ )
  SWAP /el * + @
;
: []!  ( key i a-base -- )
  SWAP /el * + !
;
: []^   ( i a-base -- a ) 
  SWAP /el * + 
;

: v[]  ( i a-base -- ai@ )
  SWAP /el * + CELL+ @
;
: v[]!  ( value  i a-base -- )
  SWAP /el * + CELL+ !
;
: v[]^   ( i a-base -- a ) 
  SWAP /el * + CELL+
;

: .ensemble ( Ens -- )    \ ��� �������
  DUP base SWAP ( a-base Ens )
  'elemcount @  0 ?DO   CR 
      I OVER [] .  I OVER v[] .
  LOOP DROP
;

: find_place  { key  l r  mas -- j }  \ l <= j <= r \ r_0 = count
\ ���������� ����� �������� � ����� �� ������ ��� �������.
  BEGIN
    r l - 2 < IF
        l r = IF  l EXIT THEN
        l mas []  key U<  IF  r EXIT THEN
        l EXIT
    THEN
    l r + 2 /
    DUP mas []     ( j j_key )
    key U<  IF -> l ELSE -> r THEN
  AGAIN
;

: _find_place  { key  l r  mas -- j }  \ l <= r ; l <= j <= r
  BEGIN
    l r <>           WHILE
    l mas [] key U<  WHILE
    l 1+ -> l
  REPEAT THEN  l
;


Public{

: ensemble+   { value key Ens \ n -- }  \ Ens-Include 
  Ens 'elemcount @   Ens 'elemcountmax @  = IF EXIT THEN
  key  0  Ens 'elemcount @   Ens base   find_place -> n
  n Ens 'elemcount @  U< IF
      n  Ens base  []   key = IF EXIT THEN
      n  Ens base  []^  DUP /el +  \ ������, ����
      Ens 'elemcount @  n - /el *  \ �������
      MOVE
  THEN
  key   n  Ens base   []!
  value n  Ens base  v[]!
  Ens 'elemcount  1+!
;

: ensemble-   { key Ens \ n -- }
  key  0  Ens 'elemcount @  Ens base   find_place -> n
  n Ens 'elemcount @  =    IF EXIT THEN
  n  Ens base  []   key <> IF EXIT THEN
  n  Ens base  []^   DUP /el +  SWAP \ ������, ����
  Ens 'elemcount @  n - 1-  /el *    \ �������
  MOVE
  -1 Ens 'elemcount  +!
;

: ensemble{}  { key Ens \ n -- value true | key Ens -- false }
  key  0  Ens 'elemcount @  DUP >R   Ens base   find_place -> n
  R> n  =  IF FALSE EXIT THEN
  n  Ens base  [] key <> IF FALSE EXIT THEN
  n  Ens base v[]  TRUE
;

: ensemble{}^  { key Ens \ n -- a  } \ ������ ������� �������, ���� ����.
  key  0  Ens 'elemcount @   Ens base   find_place -> n
  n Ens 'elemcount @  U< IF 
      n  Ens base  []   key = IF \ �������.
        n  Ens base  v[]^   EXIT
      THEN
      Ens 'elemcount @   Ens 'elemcountmax @  = IF 0 EXIT THEN

      n  Ens base  []^  DUP /el +  \ ������, ����
      Ens 'elemcount @  n - /el *  \ �������
      MOVE
  ELSE \ �� �������
      Ens 'elemcount @   Ens 'elemcountmax @  = IF 0 EXIT THEN
  THEN
  Ens 'elemcount  1+!
  key  n  Ens base   []!
       n  Ens base  v[]^
  DUP 0!
;

: Ensemble-ForEach  ( xt Ens -- )  
\ xt ( value -- )
  DUP base CELL+ ( skip key ) SWAP 'elemcount @   /el * OVER + SWAP ?DO  ( xt )
      I @ SWAP DUP >R EXECUTE R>
  /el +LOOP  DROP
;
        
: Ensemble-Volume ( Ens -- volume )  \ Ensemble-Power \?
  'elemcount @
;

: .ensemble  .ensemble ;


}Public

}PrevVoc
\EOF
 ( example:
: test  { \ ens -- }
  10  New-Ensemble -> ens
  10  0 DO I 2/   I ens ensemble+  LOOP
  11 -1 DO CR I . I ens ensemble{} IF . ELSE ." not found" THEN LOOP
  ens Del-Ensemble
; \ )

 ( example:
REQUIRE .S lib\include\tools.f
: .el  \ a -- \
\  CR .S DUP CELL- @ . @ .  
   CR .S .
;
: test  
  12  New-Ensemble 
  10  0 DO DUP I 2/   I ROT ensemble+  LOOP
  11 -2 DO CR I . I OVER ensemble{} IF . ELSE ." not found" THEN LOOP
  11 -2 DO CR I . I OVER ensemble{}^ ?DUP IF @ . ELSE ." out of band" THEN  LOOP
  CR
  ['] .el OVER Ensemble-ForEach
  Del-Ensemble
; \ )

 (
ALSO vocEnsemble  DEFINITIONS
10 Create-Ensemble  ens
0 10  ens ensemble+ 
1 11  ens ensemble+ 
2 09  ens ensemble+ 
\ )
