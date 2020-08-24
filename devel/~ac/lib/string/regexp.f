( ���������� ������ � Perl-��������� ����������� �����������
  ��� ��������� �����.

     Regular expression support is provided by the PCRE library package,
     which is open source software, written by Philip Hazel, and copyright
     by the University of Cambridge, England.
     ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/

     PCRE wrapped for SP-Forth 17.09.2002 by Andrey Cherezov
     v1.0

  �������� �������:

  PcreGetMatch [ addr1 u1 add2 u2 -- an un an-1 un-1 ... a1 u1 n ]
  �������� ������ addr1 u1 � �������� addr2 u2
  ���� ������ �� ������� - ��������� 0.
  ���� ������� - � ���������� n>0, � ��� ��� �� ����� n �����
  � ������� addr u. ��� ������, ������� ������� ��� �������-������
  � �������� �������. ������ �� ����� � ����� �������, ���
  ��������� ����� � ������� ��������� � �������.
  ������ ������� ������ - ��������� �������� ������, ��������
  ��� ������ ������.

  ��������, ������ �����������:
)
\  S" one two three" S" (\S+)\s+(\S+)\s+(\S+)" PcreGetMatch
\  . CR TYPE CR TYPE CR TYPE CR TYPE CR 
(
  ���� ���������:

  4
  one two three
  one
  two
  three

  ���� ���������� �� �����, �� ����� ������������ ����� ������� �����

  PcreMatch [ addr1 u1 add2 u2 -- matched ]
  ���������� 0, ���� ������ addr2 u2 �� ������ � ������ addr1 u1.
  ���� ������, �� ��������� - ������ ����.

  ���������� �� ������� �������������. �� �� ��������� ������
  ��������� ����� PcreEnd - ���������� ������ _pcre_vector.

  ���������� �� ������� �� ������ ��������� SPF, �� ������� pcre.dll,
  ��� ���������� ���������������� regexp � �����������, � �����
  ����� ���� wrapper ��� �����.
)

  
WINAPI: FreeLibrary  KERNEL32.DLL
WINAPI: pcre_compile pcre.dll
WINAPI: pcre_exec    pcre.dll

: PcreFree ( re -- ior )
\ �������� �������� �� ���������� :)
\ GetProcAddress ����� ���������� �� ����� �������, � ����� ����������,
\ ���������� ����� �������
  S" pcre_free" DROP S" pcre.dll" DROP LoadLibraryA DUP >R GetProcAddress @
  API-CALL NIP 1 = IF 0 ELSE -3012 THEN
  R> FreeLibrary DROP
;
USER _pcre_erroffset 
USER _pcre_error
USER _pcre_vector
60 VALUE _pcre_vector_len

\ -3010 - incorrect pattern
\ -3011 - vector too small
\ -3012 - wrong memory pointer for pcre_free()

: PcreEnd ( -- )
  _pcre_vector @ ?DUP IF FREE DROP _pcre_vector 0! THEN
;
: PcreCompile ( addr u -- re ior )
  DROP >R
  0 _pcre_erroffset _pcre_error 0 R>
  pcre_compile >R 2DROP 2DROP DROP R>
  DUP 0= IF -3010 ELSE 0 THEN
;
: PcreExec ( addr u re -- matched ior )
  >R 2>R
  _pcre_vector_len _pcre_vector @ 
  DUP 0= IF DROP _pcre_vector_len ALLOCATE THROW DUP _pcre_vector ! THEN
  0 0 2R> SWAP 0 R> 
  pcre_exec >R 2DROP 2DROP 2DROP 2DROP R>
  DUP   0= IF -3011 EXIT THEN
  DUP -1 = IF DROP 0 0 EXIT THEN \ �� �������� � ������
  DUP   0< IF 0 SWAP EXIT THEN   \ ���� ������ pcre
  0 \ ������������� ����� ��������, ��� ������ �������
    \ 1 = "������ �������", ���������� ��������� ���������
    \ 1> = ���������� ��������� ��� (...)
;
\ S" ^P(.+)Z" PcreCompile THROW S" PcReIsRULEZZ:)" ROT PcreExec THROW .

: PcreMatch ( addr1 u1 add2 u2 -- matched )
\   PcreCompile THROW PcreExec THROW
  PcreCompile THROW
    DUP >R
  PcreExec 
    R> PcreFree DROP
  THROW
;
\ S" PcReIsRULEZZ:)" S" ^P(.+)Z"  PcreMatch .
\ S" ���� ��� ���" S" (\S+)" PcreMatch . _pcre_vector @ 20 DUMP

: PcreExpandResult ( addr1 n -- an un an-1 un-1 ... a1 u1 n )
\ ���� �� ���������� ���������� ������ � ����������-���������� _pcre_vector
  DUP 2* CELLS _pcre_vector @ + \ addr1 n addr+n*2(pos)
  SWAP DUP >R
  0 DO                   \ ... addr1 pos
      CELL- DUP @        \ ... addr1 pos- offse
      SWAP CELL- DUP @   \ ... addr1 offse pos-- offsn
      SWAP >R            \ ... addr1 offse offsn
      DUP >R - R>        \ ... addr1 un offsn
      SWAP >R OVER +     \ ... addr1 an
      R> ROT             \ ... an un addr1
      R>                 \ ... an un addr1 pos--
  LOOP                   \ ... addr1 pos
  2DROP R>
;
: PcreGetMatch ( addr1 u1 add2 u2 -- an un an-1 un-1 ... a1 u1 n )
  2OVER DROP >R
  PcreCompile THROW
    DUP >R
  PcreExec ?DUP IF R> PcreFree DROP THROW THEN
  DUP 0= IF R> PcreFree DROP RDROP EXIT THEN
  2R> >R
  SWAP PcreExpandResult
  R> PcreFree THROW
;
\ S" PcReIsRULEZZ:)" S" ^P(.+)ZZ:"  PcreGetMatch . CR TYPE CR TYPE CR
\ ���������: 2 "PcReIsRULEZZ:" "cReIsRULE"
\ S" one two three" S" (\S+)\s+(\S+)\s+(\S+)" PcreGetMatch . CR TYPE CR TYPE CR TYPE CR TYPE CR 
\ ���������: 4 "one two three" "one" "two" "three"

\ : TEST
\   S" (\S+)\s+(\S+)\s+(\S+)" PcreCompile THROW >R
\   S" one two three" R@ PcreExec . .
\   S" 7 8 9" R@ PcreExec . .
\   S" ab cd ef" R@ PcreExec . .
\   S" ��� ��� ���" R@ PcreExec . .
\   S" something" R@ PcreExec . .
\   RDROP
\ ; TEST
