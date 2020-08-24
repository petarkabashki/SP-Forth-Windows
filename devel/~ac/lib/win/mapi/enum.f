REQUIRE {              ~ac/lib/locals.f
REQUIRE PT_STRING8     ~ac/lib/win/mapi/const.f
REQUIRE IID_IMAPISession ~ac/lib/win/mapi/interfaces.f

: MapiRowProp@ { row pt \ addr nprop prow -- val1 val2 true  | false }
\ ������� ������ � �������� ��������, ���� ����� �������� � ������ ����
  row CELL+ @ -> nprop row CELL+ CELL+ @ -> addr
  nprop 0 ?DO
    addr I 16 * + -> prow
    prow @ pt =
    IF prow CELL+ CELL+ CELL+ @  prow CELL+ CELL+ @ \ addr u ��� binary ��� 0 addr ��� ������
       UNLOOP TRUE EXIT
    THEN
  LOOP FALSE
;
: MapiRowStr@ { row pt -- val1 val2 true  | false }
  row pt MapiRowProp@
  IF pt 0xFFFF AND PT_STRING8 =
     IF NIP ASCIIZ> THEN TRUE
  ELSE FALSE THEN
;
: MapiRow@ { rs pt val1 val2 -- row }
\ ����� � ������ ������� ������ � �������� ��������� ��������
  rs
  DUP CELL+ SWAP @ 0 ?DO
    DUP I 12 * +
      ( row ) pt MapiRowProp@
      IF pt 0xFFFF AND PT_STRING8 = 
         IF NIP ASCIIZ> val1 val2 COMPARE 0=
         ELSE val2 = SWAP val1 = AND THEN
         IF I 12 * + UNLOOP EXIT THEN
      THEN
  LOOP DROP 0
;
: MapiProp@ { cobj pr \ np arr val -- x1 x2 }
\ ��. ����� HrGetOneProp
  1 -> np  \ ^ np ��������� �� ������ ������� ���� CREATE RootProp 1 , PR_IPM_SUBTREE_ENTRYID ,
  ^ arr ^ val 0 ^ np cobj ::GetProps 
  DUP MAPI_W_ERRORS_RETURNED = IF DROP 0 0 EXIT THEN THROW
  val IF arr CELL+ CELL+ CELL+ @ arr CELL+ CELL+ @ 
         arr @ 0xFFFF AND PT_STRING8 = 
         IF NIP ASCIIZ> THEN
      ELSE 0 0 THEN
;
: MapiProp! { x1 x2 cobj pr \ obj -- }
  cobj -> obj 0 -> cobj \ ��������� props �� ����� ���������
  pr 0xFFFF AND PT_STRING8 =
  IF x1 -> x2 0 -> x1 THEN
  0 ^ pr 1 obj ::SetProps THROW
;
: MapiForEach { rs xt -- }
\ ��������� xt ��� ������� �������� ������ �������
  rs
  DUP CELL+ SWAP @ 0 ?DO
    DUP I 12 * + xt EXECUTE
  LOOP DROP
;
