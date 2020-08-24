REQUIRE INVOKE ~ac/lib/ns/ns.f 

: ?FORTH ( wid -- flag )
  CLASS@ DUP 0= SWAP FORTH-WORDLIST = OR
;
: CAR ( wid -- item )
\ ���������� oid ������� �������� ������ wid.
  DUP ?FORTH
  IF @ ELSE DUP S" CAR" INVOKE THEN
;
: WCDR ( item1 wid -- item2 )
\ ���������� ��������� ����� item1 ������� ������ wid.
  DUP ?FORTH
  IF DROP CDR ELSE S" CDR" INVOKE THEN
;
: CDR ( item1 -- item2 )
\ ���������� ��������� ����� item1 ������� ������������ ������.
  CONTEXT @ WCDR
;
: W?VOC ( item wid -- flag )
\ ���������� true, ���� ������� item ������ wid �������� �������.
  DUP ?FORTH
  IF DROP ?VOC ELSE S" ?VOC" INVOKE THEN
;
: ?VOC ( item -- flag )
\ ���������� true, ���� ������� item ������������ ������ �������� �������.
  CONTEXT @ W?VOC
;
: WNAME ( item wid -- addr u )
\ ���������� ��� �������� item ������ wid.
  DUP ?FORTH
  IF DROP COUNT ELSE S" NAME" INVOKE THEN
;
: NAME ( item -- addr u )
\ ���������� ��� �������� item ������������ ������.
  CONTEXT @ WNAME
;
: NFA>WID ( nfa -- wid )
  NAME> >BODY @
;
: >WID ( item -- wid )
;
: ITEM>WID ( item wid1 -- wid2 )
\ ���������� ������ wid2, ��������� � ������� item ������ wid1. (lisp car)
  DUP ?FORTH
  IF DROP NFA>WID ELSE S" >WID" INVOKE THEN
;

: ForEach ( xt wid -- )
  CAR
  BEGIN
    DUP
  WHILE
    2DUP SWAP EXECUTE
    CDR
  REPEAT 2DROP
;
: ForEachW ( xt wid -- )
\ xt: ( item wid -- )
  DUP >R
  CAR
  BEGIN
    DUP
  WHILE
    2DUP R@ ROT EXECUTE
    CDR
  REPEAT 2DROP RDROP
;
: ForEachDir ( xt wid -- )
  CAR
  BEGIN
    DUP
  WHILE
    DUP ?VOC IF 2DUP SWAP EXECUTE THEN
    CDR
  REPEAT 2DROP
;
: ForEachR ( xt wid -- )
  CAR
  BEGIN
    DUP
  WHILE
    DUP ?VOC IF 2DUP NFA>WID RECURSE THEN
    2DUP SWAP EXECUTE
    CDR
  REPEAT 2DROP
;
: ForEachWR ( xt wid -- )
\ xt: ( item wid -- )
  DUP >R
  CAR
  BEGIN
    DUP
  WHILE
    DUP R@ W?VOC
    IF 2DUP R@ ITEM>WID RECURSE THEN
    2DUP R@ ROT EXECUTE
    R@ WCDR
  REPEAT 2DROP RDROP
;
: ForEachDirR ( xt wid -- )
  CAR
  BEGIN
    DUP
  WHILE
    DUP ?VOC 
    IF 2DUP NFA>WID RECURSE
       2DUP SWAP EXECUTE
    THEN
    CDR
  REPEAT 2DROP
;

: ForEachDirWR ( xt wid -- )
\ xt: ( item wid -- )
  DUP >R
  CAR
  BEGIN
    DUP
  WHILE
    DUP R@ W?VOC
    IF 2DUP R@ ITEM>WID RECURSE
       2DUP R@ ROT EXECUTE
    THEN
    R@ WCDR
  REPEAT 2DROP RDROP
;
: ForEachNdirWR ( xt wid -- )
\ xt: ( item wid -- )
  DUP >R
  CAR
  BEGIN
    DUP
  WHILE
    DUP R@ W?VOC
    IF 2DUP R@ ITEM>WID RECURSE
    ELSE 2DUP R@ ROT EXECUTE THEN
    R@ WCDR
  REPEAT 2DROP RDROP
;
: ForEachNdirW ( xt wid -- )
\ xt: ( item wid -- )
  DUP >R
  CAR
  BEGIN
    DUP
  WHILE
    DUP R@ W?VOC 0=
    IF 2DUP R@ ROT EXECUTE THEN
    R@ WCDR
  REPEAT 2DROP RDROP
;

: id. NAME TYPE CR ;
: wid. WNAME TYPE CR ;
\ ' id. FORTH-WORDLIST ForEachR
\ ' id. ALSO DL CONTEXT @ ForEachR PREVIOUS
\ ' wid. FORTH-WORDLIST ForEachDirWR

\ ALSO DL NEW: USER32.DLL
\ ' id. CONTEXT @ ForEach PREVIOUS
\ ' wid. CONTEXT @ ForEachDirWR PREVIOUS
