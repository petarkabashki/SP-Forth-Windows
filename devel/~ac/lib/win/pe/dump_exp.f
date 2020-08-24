\ ������ ������ �������� (��. ������������ PE-������ � MIPS-������ MIPSDIS 98�) ��� ��������
\ ����������� ������� �������������� �������� �����. 
\ ������ ��������� Windows ��� ��������� ������ �������� dll, �� � ���� ���� ��� ��� :)

REQUIRE /PE-HEADER            ~ac/lib/win/pe/pe_header.f 
REQUIRE /ExportDirectoryTable ~ac/lib/win/pe/pe_export.f 
REQUIRE {                     lib/ext/locals.f

: DUMP-EXP { addr u \ h pe_offs rvas sects exp exp_size o erva esize ef_offs ef_size f bas -- }

  addr u R/O OPEN-FILE-SHARED THROW -> h
  PAD 0x40 h READ-FILE THROW DROP
  BASE @ -> bas HEX
  PAD 0x3C + @  \ �������� �� PE
  DUP -> pe_offs
  S>D h REPOSITION-FILE THROW

  PAD /PE-HEADER h READ-FILE THROW DROP
  PAD ExportTableRVA @ -> exp
  PAD TotalExportDataSize @ -> exp_size
  PAD #InterestingRVA/Sizes @ -> rvas
  PAD #Objects W@ -> sects
  pe_offs Magic \ �������� �� ������������� ���������
  PAD NTHDRsize W@ \ ������ ������������� ���������
  + S>D h REPOSITION-FILE THROW

  PAD sects /ObjectTable *  h READ-FILE THROW DROP
  sects 0 DO
    I /ObjectTable * PAD + -> o
    o ASCIIZ> TYPE SPACE
    o OT.RVA @ . o OT.VirtualSize @ .
    exp o OT.RVA @ DUP o OT.VirtualSize @ + WITHIN DUP .
    IF o OT.RVA @ -> erva  o OT.VirtualSize @ -> esize \ ��������� ������, � ������� export table (exp), �� ����������� � ������
       o OT.PhisicalOffset @ -> ef_offs  o OT.PhisicalSize @ -> ef_size
    THEN
    CR
  LOOP

  exp erva - ( �������� � ������) ef_offs + S>D h REPOSITION-FILE THROW
  HERE exp_size h READ-FILE THROW DROP
\  S" exp.bin" R/W CREATE-FILE THROW -> f
\  HERE exp_size f WRITE-FILE THROW
\  f CLOSE-FILE THROW
  HERE ED.NameRVA @ exp - HERE + ASCIIZ> TYPE CR \ ���������, ��� ��������� ����� �������

  HERE ED.AddressTableEntries @ . HERE ED.NumberOfNamePointers @ . CR
  HERE ED.OrdinalBase @ . CR
  HERE ED.NumberOfNamePointers @ 0 ?DO
    HERE ED.NamePointerRVA @ exp - HERE +
    I CELLS + @ ( rva) exp - HERE + ASCIIZ> TYPE SPACE
    HERE ED.OrdinalTableRVA @ exp - HERE +
    I 2* + W@ 1+ ( �����) DUP ." #" . HERE ED.OrdinalBase @ - CELLS \ ��������
    HERE ED.ExportAddressTableRVA @ exp - HERE + + @ \ rva - ���� �������������� ������, ���� ��������� �� ���������
    DUP exp DUP exp_size + WITHIN IF exp - HERE + ASCIIZ> ." ->" TYPE SPACE ELSE . THEN
  LOOP
  h CLOSE-FILE THROW
  bas BASE !
;
\ S" c:\windows\system32\kernel32.dll" DUMP-EXP
\ S" F:\openssl\openssl.exe" DUMP-EXP
\ S" test.exe" DUMP-EXP
