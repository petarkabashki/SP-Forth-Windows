REQUIRE &DP-HOOK ~profit/lib/dp-hook.f
REQUIRE NO-INLINE{ ~profit/lib/no-inline.f
REQUIRE SEE lib/ext/disasm.f

VECT NEXT

:NONAME
HERE LAST-HERE <> IF EXIT THEN
HERE OP0 @ <> IF EXIT THEN
POSTPONE NEXT ; &DP-HOOK !

NO-INLINE{
: r 10 0 DO I DUP * . LOOP ;
}NO-INLINE
SEE r