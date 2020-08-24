\ 23.Dec.2006 Sat 16:08
( ��������� ������-������ ��� ������� ����
  � ����� �� ����������. ��� ������� �� quick-swl3.f

  ����� WID-EXTRA [ wid -- addr ] ���� �������� ������ ��� �������������.
  ������ ������ ����������, ������� ����� ��� ������ ��� ����� ����,
  ������ �������������� ����� WID-EXTRA � ���, ����� ��� ���������� 
  ������ ��������� ������.

  ������ ������������� ������� AT-WORDLIST-CREATING [ wid -- wid ]
  ���������� ��� �������� ������ ������ ����.

  ���������� ������ "����� �������" � ��������� ������� ��� ���������� ���������,
  � �������������� CLASS! � CLASS@ 
  [ �.�. �������������� �� ������ ������ � ��������� ������������� ;]
)

REQUIRE [UNDEFINED] lib/include/tools.f
REQUIRE Included ~pinka/lib/ext/requ.f

[DEFINED] WID-EXTRA [IF] Include wid-extra2.f \EOF [THEN]

REQUIRE REPLACE-WORD lib/ext/patch.f

WARNING @  WARNING 0!

MODULE: WidExtraSupport

Require ENUM-VOCS enum-vocs.f

4 CELLS CONSTANT /THIS-EXTR   \ [ hash-table | storage-id | voc class | free cell ]

: MAKE-EXTR ( wid -- )
  HERE DUP /THIS-EXTR DUP ALLOT ERASE
  ( wid here )
  OVER CLASS@ OVER CELL+ CELL+ !
  SWAP CLASS!
;
: MAKE-EXTR2 ( wid -- ) \ �� ������������; �� ������ ��������, ��������� ����� ����� WORDLIST
  GET-CURRENT >R  DUP SET-CURRENT
  MAKE-EXTR
  R> SET-CURRENT
;

EXPORT

: WID-EXTRA ( wid -- a )  \ ����� ��������� ��� ������ ���������� ������
  3 CELLS + \ an old "class of vocabulary" cell 
  @  3 CELLS +  \ ����������� ��� ��� ��������� ������� :)
;

DEFINITIONS

: WID-CLASSA ( wid -- a )
  WID-EXTRA CELL-
;

: WID-STORAGEA ( wid -- a )
  WID-EXTRA CELL- CELL-
;

: WID-CACHEA ( wid -- a )
  WID-EXTRA 3 CELLS -  \ � ��� ����������� ��� ��������� ������� :)
;


EXPORT

WARNING @ WARNING 0!
: CLASS! ( cls wid -- ) WID-CLASSA ! ;
: CLASS@ ( wid -- cls ) WID-CLASSA @ ;
WARNING !

: AT-WORDLIST-CREATING ( wid -- wid ) ... ;

\ : WORDLIST ( -- wid )
\   WORDLIST DUP MAKE-EXTR AT-WORDLIST-CREATING ( wid )
\ ;

\ ���� �������� ��� storage.f, ����� ��������� ����� VOC-LIST

( WORDLIST ���� ��������������,
  �.�. ��������� ������������ ��� ��������� �� ������ VOC-LIST
  �������� �� ������� ����������.
)
' WORDLIST  \ see compiler/spf_wordlist.f
: WORDLIST ( -- wid ) \ 94 SEARCH
  HERE VOC-LIST @ , VOC-LIST !
  HERE 0 , \ ����� ����� ��������� �� ��� ���������� ����� ������
       0 , \ ����� ����� ��������� �� ��� ������ ��� ����������
       0 , \ wid �������-������
       0 , \ ����� ������� = wid �������, ������������� �������� �������

  DUP MAKE-EXTR AT-WORDLIST-CREATING ( wid )
;

' WORDLIST SWAP REPLACE-WORD

: TEMP-WORDLIST ( -- wid )
  GET-CURRENT >R
  TEMP-WORDLIST DUP SET-CURRENT DUP MAKE-EXTR ( wid ) AT-WORDLIST-CREATING ( wid )
  R> SET-CURRENT
;

\ : VOCABULARY
\   VOCABULARY  VOC-LIST @ CELL+
\   DUP MAKE-EXTR AT-WORDLIST-CREATING DROP
\ ;

' VOCABULARY
: VOCABULARY  \ see  compiler/spf_defwords.f
  CREATE
  HERE 0 , \ cell for wid
  WORDLIST ( addr wid )
  LATEST OVER VOC-NAME! \ ������ �� ��� �������
  GET-CURRENT OVER PAR! \ �������-������
  \ FORTH-WORDLIST SWAP CLASS! ( ����� )
  SWAP ! \ ��� wid
  VOC    \ ������� "�������"
  DOES> @ CONTEXT !
;
' VOCABULARY SWAP REPLACE-WORD  \ ����� �������� � �� 'MODULE:', � ���� ���������� �� storage.f


' MAKE-EXTR ENUM-VOCS \ ���� ������������ �������� (!!!)

Include enum-vocs.f \ ��������������� �� ����� CLASS@

;MODULE

WARNING !