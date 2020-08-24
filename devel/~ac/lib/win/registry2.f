( 02.08.1999 ������� �. )
\ 28.03.2001 ����������
\ 10.07.2001 ������� registry.f ��� locals.f

( ������ � Windows Registry, ������ ���������� reg.txt ���������� ��������.
  �������� �����: 
  StrValue, NumValue � BinValue - �������� ��������, �������� � ��������
  �������� �������� ������ registry.
  �� �� ����� � "!" �� ����� - ����������. ���� ���������� ����� ���,
  �� ����� ������������� ������.
  ��� ����� �������� � �������� �� ��������� ������� "���������" �����,
  �������� � ���������� EK. ������ ���������� ���� ����� ������ "���������"
  � Registry � �������� � ����� ��������� �������� ���� ������ [��. �������]
  ����� ��� ������������ ������� ������ � ��������:
  RG_ForEachKey � RG_ForEachValue
  ��������� ����� � �������� xt ��� ������� ����� ��� ��������.
)

REQUIRE { ~ac/lib/locals.f

WINAPI: RegQueryValueExA ADVAPI32.DLL
WINAPI: RegOpenKeyA      ADVAPI32.DLL
WINAPI: RegCloseKey      ADVAPI32.DLL
WINAPI: RegCreateKeyA    ADVAPI32.DLL
WINAPI: RegSetValueExA   ADVAPI32.DLL
WINAPI: RegEnumKeyA      ADVAPI32.DLL
WINAPI: RegEnumValueA    ADVAPI32.DLL

HEX
80000000 CONSTANT HKEY_CLASSES_ROOT
80000001 CONSTANT HKEY_CURRENT_USER
80000002 CONSTANT HKEY_LOCAL_MACHINE
80000003 CONSTANT HKEY_USERS
80000004 CONSTANT HKEY_PERFORMANCE_DATA \ WinNT/2000
\ #if(WINVER >= 0x0400)
80000005 CONSTANT HKEY_CURRENT_CONFIG
80000006 CONSTANT HKEY_DYN_DATA
DECIMAL

 0 CONSTANT REG_NONE
 1 CONSTANT REG_SZ
 2 CONSTANT REG_EXPAND_SZ
 3 CONSTANT REG_BINARY
 4 CONSTANT REG_DWORD
 4 CONSTANT REG_DWORD_LITTLE_ENDIAN
 5 CONSTANT REG_DWORD_BIG_ENDIAN
 6 CONSTANT REG_LINK
 7 CONSTANT REG_MULTI_SZ
 8 CONSTANT REG_RESOURCE_LIST
 9 CONSTANT REG_FULL_RESOURCE_DESCRIPTOR
10 CONSTANT REG_RESOURCE_REQUIREMENTS_LIST

: RG_OpenKey ( addr u key -- h ior )
  { \ h }
  NIP ^ h ROT ROT
  RegOpenKeyA h SWAP
;
: RG_CreateKey ( addr u key -- h ior )
  { \ h }
  NIP ^ h ROT ROT
  RegCreateKeyA h SWAP
;
: RG_ForEachKey ( xt h -- )
  { xt h \ mem index }
  1024 ALLOCATE THROW -> mem
  0 -> index
  BEGIN
    1000 mem index h RegEnumKeyA
    index 1+ -> index
    DUP 0= IF mem ASCIIZ> xt EXECUTE THEN
  UNTIL
  mem FREE THROW
;
: RG_ForEachValue ( xt h -- )
  { xt h \ name data index }
  1024 ALLOCATE THROW -> name
  1024 ALLOCATE THROW -> data
  0 -> index
  BEGIN
    data 1000 OVER ! data CELL+ CELL+
    data CELL+ 0 \ type and reserved
    name 1000 OVER ! name CELL+
    index h RegEnumValueA
    index 1+ -> index
    DUP 0= 
    IF name CELL+ name @ data CELL+ CELL+ data @ data CELL+ @ 
       DUP REG_SZ = IF SWAP 1- 0 MAX SWAP THEN
       xt EXECUTE 
    THEN
  UNTIL
  name FREE THROW data FREE THROW
;
: RG_QueryValue ( valuename-a valuename-u h -- addr u type )
  { \ data cbdata type name key }
  -> key DROP -> name
  1024 ALLOCATE THROW -> data  1000 -> cbdata
  ^ cbdata data ^ type 0 name key RegQueryValueExA
  DUP 0= IF DROP data cbdata type ELSE data 0 ROT THEN
  \ ����������� �� FREE ������������ data ������ ���������� ���������!
  \ type=1=REG_SZ - ������, 4=REG_DWORD - �����
;
: RG_SetValue ( addr u type valuename-a valuename-u h -- )
  { a u t na nu key \ c mem }
  t REG_SZ = 
  IF u 1+ ALLOCATE THROW -> mem  a mem u MOVE 0 mem u + C!
     u 1+ mem
  ELSE u a THEN
  t 0 na key RegSetValueExA DROP
  t REG_SZ =
  IF mem FREE THROW THEN
;
VARIABLE EK
HKEY_LOCAL_MACHINE EK !

: Value ( valuename-a valuename-u keyname-a keyname-u -- addr u type )
  EK @ RG_OpenKey
  IF DROP 2DROP ( S" ") 1 ALLOCATE THROW 0  0
  ELSE RG_QueryValue THEN
;
: Value! ( addr u type valuename-a valuename-u keyname-a keyname-u -- )
  EK @ RG_CreateKey
  IF DROP 2DROP DROP 2DROP
  ELSE RG_SetValue THEN
;

: StrValue ( valuename-a valuename-u keyname-a keyname-u -- addr u )
  Value REG_SZ = IF DROP ASCIIZ> ( 1- 0 MAX ( zero in asciiz) EXIT THEN
\  -4010 THROW
;
: NumValue ( valuename-a valuename-u keyname-a keyname-u -- x )
  Value REG_DWORD = IF DROP DUP @ SWAP FREE DROP EXIT THEN
\  -4011 THROW
  DROP FREE DROP 0
;
: BinValue ( valuename-a valuename-u keyname-a keyname-u -- addr u )
  Value REG_BINARY = IF EXIT THEN
\  -4012 THROW
;
: StrValue! ( addr u valuename-a valuename-u keyname-a keyname-u -- )
  2>R 2>R REG_SZ 2R> 2R> Value!
;
: NumValue! ( x valuename-a valuename-u keyname-a keyname-u -- )
  2>R 2>R SP@ 4 REG_DWORD 2R> 2R> Value! DROP
;
: FormatV ( addr u type -- addr u )
  DUP REG_SZ = IF DROP 1- 0 MAX EXIT THEN
  DUP REG_DWORD = IF 2DROP @ 0 <# #S #> EXIT THEN
  2DROP 0
\  -4013 THROW
;
: FormatValue ( valuename-a valuename-u keyname-a keyname-u -- addr u )
  Value FormatV
;

\ �������:
\ : OpenEservRegistry ( -- h ior )
\   S" SOFTWARE\Etype\Eserv" HKEY_LOCAL_MACHINE RG_OpenKey OVER EK !
\ ;
\ : TYPECR ( addr u -- )
\   TYPE CR
\ ;
\ : TYPETYPECR ( addr u addr u type -- )
\   FormatV 2SWAP TYPE SPACE TYPE CR
\ ;
\ : TEST
\   || ek ||
\   OpenEservRegistry DUP 0=
\   IF DROP -> ek
\    S" MailServer\SMTPserver\LocalDomains" ek RG_OpenKey THROW
\    ['] TYPECR SWAP RG_ForEachKey
\    S" ProxyServer" ek RG_OpenKey THROW
\    ['] TYPETYPECR SWAP RG_ForEachValue
\    S" HttpsRoutingHost" S" ProxyServer" StrValue TYPE CR
\    S" HttpsRoutingPort" S" ProxyServer" NumValue . CR
\    3130 S" HttpsRoutingPort" S" ProxyServer" NumValue!
\    S" abcde" S" HttpsRoutingHost" S" ProxyServer" StrValue!
\   ELSE NIP THEN
\ ;

\ : RG_QueryBigValue ( valuename-a valuename-u h -- addr u type )
\   | data cbdata type name key |
\   key ! DROP name !
\   100000 ALLOCATE THROW data !  100000 cbdata !
\   cbdata data @ type 0 name @ key @ RegQueryValueExA
\   DUP 0= IF DROP data @ cbdata @ type @ ELSE S" " ROT THEN
\   \ ����������� �� FREE ������������ data ������ ���������� ���������!
\   \ type=1=REG_SZ - ������, 4=REG_DWORD - �����
\ ;

\ : TEST
\   S" Global" HKEY_PERFORMANCE_DATA RG_QueryBigValue
\ ;
