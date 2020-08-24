REQUIRE JMP ~pinka/lib/tools/jmp.f

: SFIND1 ( addr u -- addr u 0 | xt 1 | xt -1 ) \ 94 SEARCH
  S-O 1- CONTEXT
  DO
   2DUP I @ SEARCH-WORDLIST
    DUP IF 2SWAP 2DROP UNLOOP EXIT THEN DROP
   I S-O = IF LEAVE THEN
   1 CELLS NEGATE
  +LOOP
  0
;

' SFIND
VECT SFIND   ' SFIND1 TO SFIND

' SFIND SWAP JMP


\ SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH

: SFIND2 ( addr u -- addr u 0 | xt 1 | xt -1 )
  SFIND1 DUP IF EXIT THEN DROP
  2DUP 2>R
  S" ::" SPLIT- 0= IF 2DROP 2R> FALSE EXIT THEN
  ( a2 u2 a1 u1 )
  SFIND1 0= IF 2DROP 2DROP 2R> FALSE EXIT THEN
  SP@ >R
  EXECUTE ( a2 u2 wid )
  SP@ R> <> IF ABORT THEN
  ( a2 u2 wid )
  SEARCH-WORDLIST DUP IF RDROP RDROP EXIT THEN DROP
  2R> FALSE
;

' SFIND2 TO SFIND
