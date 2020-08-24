REQUIRE (dllinit) ~ygrek/lib/far/plugindll.f
REQUIRE NEWDIALOG ~ygrek/lib/far/control.f

1234 CONSTANT SOMETHING

' STARTLOG TO FARPLUGIN-INIT

( 
 �㭪�� GetMsg �����頥� ��ப� ᮮ�饭�� �� �몮���� 䠩��.
 � �� �����ன�� ��� Info.GetMsg ��� ᮪�饭�� ���� :-)

: GetMsg ( MsgId -- pchar ) FARAPI. ModuleNumber @ FARAPI. GetMsg @ API-CALL ;

:NONAME DUP 1+ SWAP CREATE , DOES> @ GetMsg ; ENUM MESSAGES=

0 
 MESSAGES= MTitle MMessage1 MMessage2 MMessage3 MMessage4 MButton ;
DROP

( 
�㭪�� SetStartupInfo ��뢠���� ���� ࠧ, ��। �ᥬ�
��㣨�� �㭪�ﬨ. ��� ��।����� ������� ���ଠ��,
����室���� ��� ���쭥�襩 ࠡ���.
)

:NONAME ( psi -- void )
  FARAPI. /SIZE CMOVE
  SOMETHING
; 1 CELLS CALLBACK: SetStartupInfo

( 
�㭪�� GetPluginInfo ��뢠���� ��� ����祭�� �᭮����
  [general] ���ଠ樨 � �������
)

VARIABLE MyPluginMenuStrings \ array[0..0] of PChar;
VARIABLE MyPluginConfigStrings

:NONAME { pi \ -- void }  
   TEMPAUS TPluginInfo pi

   pi. /SIZE NIP  pi. StructSize !

   W: PF_VIEWER pi. Flags !

   MTitle MyPluginMenuStrings !
   MyPluginMenuStrings pi. PluginMenuStrings !

   1 pi. PluginMenuStringsNumber !

   MTitle MyPluginConfigStrings !
   MyPluginConfigStrings pi. PluginConfigStrings !

   1 pi. PluginConfigStringsNumber !

  SOMETHING \ �����頥� ��-�����
; 1 CELLS CALLBACK: GetPluginInfo

0 VALUE .output
0 VALUE .input

: MakeGrid ( -- grid )

   0 TO Items
   10 Items. get ALLOCATE THROW TO Items
   10 Items. buf ERASE
   
   GRID
    GRID
     " SPF:" label |
     " 2 2 + . " edit  -xspan  20 1 this ctlresize  this TO .input  |
     ===
     "" label  this TO .output |
     -boxed
    GRID; |
    ===
    "" label |
    ===
    " OK" button -xspan -center |
   GRID;

;

0 VALUE zz

: ToLabel ( a u -- )
   >ASCIIZ
   zz SWAP ZAPPEND
   zz .output -text! ;

MESSAGES: MyDlgProc

M: dn_key { \ buf -- }
    param1 .input -id@ <> IF FALSE EXIT THEN
    param2 13 <> IF FALSE EXIT THEN

    0 zz !
    zz .output -text!

    .input -text# ALLOCATE THROW TO buf
    buf .input -text@ 
    buf .input -text#
    ['] ToLabel TO TYPE
    EVALUATE
\    ['] ToLabel2 TO TYPE
\    S" OK" EVALUATE
    ['] TYPE1 TO TYPE
    DEPTH 0 ?DO DROP LOOP \ DROP all extra
    buf FREE THROW
  
    TRUE RETURN
    TRUE
M;

MESSAGES;

:NONAME ( Item OpenFrom -- Handle )
  ( 2DUP ." from = " .H ." item = " .H CR )

   2DROP 

   NEWDIALOG

    MakeGrid  winmain -grid!
    MyDlgProc winmain -dlgproc!

    1024 ALLOCATE THROW TO zz

   RUNDIALOG

    zz FREE THROW

\   5 Items. buf DUMP

   Items FREE THROW
   0 TO Items

  INVALID_HANDLE_VALUE ; 2 CELLS CALLBACK: OpenPlugin

(
  ��뢠���� �� �맮�� �� ���� ����஥� ��������
) 
:NONAME ( number -- flag )
  DROP

  TRUE
; 1 CELLS CALLBACK: Configure

