\ ������ ���������� ������� � sqlite3 � ���� JSON-�������.

REQUIRE xquery      ~ac/lib/lin/sql/sql3db.f 
REQUIRE replace-str ~pinka/samples/2005/lib/replace-str.f 

: ">\" ( addr u -- addr2 u2 )
  2DUP S' "' SEARCH NIP NIP 0= IF EXIT THEN
  " {s}" 
  DUP " \"    " \\"    replace-str-
  DUP " {''}" " \{''}" replace-str-
  DUP " {CRLF DROP 1+ 1}" " \n" replace-str-
  DUP " {CRLF DROP 1}" "" replace-str-
  STR@
;

: (jquery) { i par ppStmt -- flag }
  " [" SQS @ S+
  ppStmt db3_cols 0 ?DO
    I ppStmt db3_col DUP 0= >R 2DUP S" NULL" COMPARE 0= R> OR IF 2DROP S" " THEN
    I ppStmt db3_coltype 3 < 
    IF \ ����� �� �����������
    ELSE ">\" " {''}{s}{''}" STR@ THEN
    I 0 > IF " , {s}" ELSE "  {s}" THEN SQS @ S+
  LOOP  " ],{CRLF}" SQS @ S+
  TRUE
;
: jquery ( addr u -- addr2 u2 )
  " [{CRLF}" SQS !
  0 ['] (jquery) SQH @ db3_exec
  SQS @ STR@ DUP 3 >
  IF
    2DUP + 3 - [CHAR] ] SWAP C!
  ELSE 2DROP S" []" THEN
;
: (jquery2) { i par ppStmt -- flag }
  S" {" SQS @ STR+
  ppStmt db3_cols 0 ?DO
    I ppStmt db3_col DUP 0= >R 2DUP S" NULL" COMPARE 0= R> OR IF 2DROP S" " THEN
    I ppStmt db3_coltype 3 < 
    IF \ ����� �� �����������
    ELSE 2DUP S" true" COMPARE 0=
       IF 
       ELSE 2DUP S" false" COMPARE 0=
          IF
          ELSE ">\" " {''}{s}{''}" STR@ THEN
       THEN
    THEN
    I ppStmt db3_colname " {''}{s}{''}:{s}" STR@
    I 0 > IF " , {s}" ELSE "  {s}" THEN SQS @ S+
  LOOP  S" }" " {s},{CRLF}" SQS @ S+
  TRUE
;
: jquery2 ( addr u -- addr2 u2 )
  " [{CRLF}" SQS !
  0 ['] (jquery2) SQH @ db3_exec
  SQS @ STR@ DUP 3 >
  IF
    2DUP + 3 - [CHAR] ] SWAP C!
  ELSE 2DROP S" []" THEN
;

\EOF

: TEST2 { \ sqh res }
  S" world.db3" db3_open SQH !
  S" SELECT * FROM Country ORDER BY CODE2" jquery
  SQH @ db3_close
; TEST2 TYPE

