REQUIRE [UNDEFINED] lib/include/tools.f

: ?WINAPI: ( -- )
  >IN @
  POSTPONE [UNDEFINED]
  IF   >IN ! WINAPI:
  ELSE DROP PARSE-NAME 2DROP
  THEN
;
