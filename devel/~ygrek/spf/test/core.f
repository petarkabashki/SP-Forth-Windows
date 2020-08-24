\ $Id: core.f,v 1.2 2008/05/29 06:52:36 ygreks Exp $

REQUIRE TESTCASES ~ygrek/lib/testcase.f
REQUIRE NOT ~profit/lib/logic.f

TESTCASES FILL

100000 VALUE #buf

0 VALUE buf 
#buf CHARS ALLOCATE THROW TO buf

: check ( a u char -- ? )
   -ROT
   CHARS OVER + SWAP ?DO DUP I C@ = NOT IF DROP UNLOOP FALSE EXIT THEN /CHAR +LOOP 
   DROP TRUE ;

buf #buf CHAR a FILL
\ buf #buf 100 CHARS MIN DUMP

(( buf #buf CHAR a check -> TRUE ))

buf FREE THROW

END-TESTCASES



TESTCASES SEARCH-WORDLIST-NFA

MODULE: z
S" qua" CREATED
S" " CREATED
S" zzz" CREATED
;MODULE

ALSO z CONTEXT @ VALUE wid PREVIOUS

(( S" qua" wid SEARCH-WORDLIST-NFA NIP -> TRUE ))
(( S" " wid SEARCH-WORDLIST-NFA SWAP NAME>L TO wid -> TRUE ))
(( S" qua" wid SEARCH-WORDLIST-NFA NIP -> TRUE ))
(( S" " wid SEARCH-WORDLIST-NFA -> FALSE ))

END-TESTCASES

