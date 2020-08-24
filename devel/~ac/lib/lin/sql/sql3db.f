REQUIRE db3_open     ~ac/lib/lin/sql/sqlite3.f 

USER SQH
USER SQS

\ ## ������������ ������ ���� ������ ������ �� query

: id_query { $query -- id }
  $query STR@ SQH @ db3_get_id2 DROP \ $query STRFREE
;

\ ## ��������� ������ ������, ���� query ������ ����� 0 �����, ����� ������
\ ## ������������ ������ ���� ������ ������ �� query ��� insert_id �� query2
\ ## (�.�. �������� ������� ������ � ����)

: reg_query { $query $query1 $query2 \ id -- id }
  $query id_query DUP -> id \ $query ��� �� ������������
  IF
    $query1 STR@ SQH @ db3_exec_
  ELSE
    $query2 STR@ SQH @ db3_exec_ \ SQH @ db3_insert_id -> id
    $query id_query -> id \ ��������� ������, ����� �� �������� �� ON CONFLICT
                          \ � ������� � ������ �������
  THEN
  $query1 STRFREE  $query2 STRFREE
  $query STRFREE
  id
;
: (xquery) { i par ppStmt -- flag }
  i 1 =
  IF " <thead><tr class='sp_head'>" SQS @ S+
    ppStmt db3_cols 0 ?DO
      I ppStmt db3_colname 2DUP " <th class='{s}'>{s}</th>" SQS @ S+
    LOOP " </tr></thead>{CRLF}<tbody>" SQS @ S+
  THEN
  i 1 AND 0= IF S"  even" ELSE S" " THEN
  i " <tr N='{n}' class='sp_data{s}'>" SQS @ S+
  ppStmt db3_cols 0 ?DO
    I ppStmt db3_colu DUP 0= ( >R 2DUP S" NULL" COMPARE 0= R> OR) IF 2DROP S" &nbsp;" THEN
    I ppStmt db3_coltype 3 < IF S"  numb" ELSE S" " THEN
    I ppStmt db3_colname  " <td class='{s}{s}'>{s}</td>" SQS @ S+
  LOOP  " </tr>{CRLF}" SQS @ S+
  TRUE
;
: xquery ( addr u -- addr2 u2 )
  " <table class='sortable' id='sp_table' cellpadding='0' cellspacing='0'>" SQS !
  0 ['] (xquery) SQH @ db3_exec
  " </tbody></table>" SQS @ S+
  SQS @ STR@
;
: xquery_style ( addr u stylea styleu -- addr2 u2 )
  " <table class='sortable {s}' id='sp_table' cellpadding='0' cellspacing='0'>" SQS !
  0 ['] (xquery) SQH @ db3_exec
  " </tbody></table>" SQS @ S+
  SQS @ STR@
;
