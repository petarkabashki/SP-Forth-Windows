REQUIRE EMBODY ~pinka/spf/forthml/index.f
REQUIRE PRO    ~profit/lib/bac4th.f 
Require SFIND2 sfind-vect.f

[UNDEFINED] CELL-! [IF]
: CELL-! -1 CELLS SWAP +! ; [THEN]

[UNDEFINED] CELL+! [IF]
: CELL+!  1 CELLS SWAP +! ; [THEN]

\ S" spf-big.exe" SAVE BYE

`half-dozen.f.xml FIND-FULLNAME2 EMBODY
