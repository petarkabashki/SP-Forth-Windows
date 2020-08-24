\ ��������� ��� ������ � HIP-���
\ S" lib/include/float2.f" INCLUDED
S" ~af/lib/c/define.f" INCLUDED
1e0 32767e0 F/ FCONSTANT NETRSKOF \ (1./32767.)

#define TRMIN 30
#define TRMAX 0x8000

#define LTRTEMP 109  \ ����� ���������
#define LRSTEMP 72   \ ����� �����������

#define VERTMP   0   \ ������ �� ���������� ������
#define DATETMP  1	\ ���� �������� �������
#define SINTTMP  2	\ ������� �������
#define FMIDDLE  3   \ ������� �������
#define DEVITMP  4	\	��������
#define SPIDMODE 5   \ �������� ���������

#define OTSLEVE  0
#define MINOTS   0
#define MAXOTS   0
#define ATOTS    0
#define KOFOTS   0


#define NPARZAP 31  \ ����� ���������� ��� ������-�����������

#define VERSOFT 0
#define LONGFILE 1
#define KOFTR 2
#define BITMOL 3
#define DIGMOD 4
#define REJOTS 5
#define YROTS 6
#define KOFRS 7
#define INVTR 8
#define INVRS 9
#define KTXCOD 10
#define KRXCOD 11

#define DATEPROG5 18
#define MNSIN5 20
#define MYFRIC5 21

#define DATEPROG6 26
#define MNSIN6 28
#define MYFRIC6 29

#define ATTADC5 24
#define ATTADC6 30

\ ������� �����������
\ ������������:
#define TRSYMBOL 	0  \ �������� ��������� ������
#define TRSTOP 		1  \ ���������� ��������
#define TRSTART 	2  \ ������ ��������
#define TRLOAD 		3  \ ��������� ����� ����������
#define DACOUT 		4  \ �������� ��������� ������ �����������
#define TRATTEN 	5  \ �������� ���������� DAC
#define TRLSYM 		6  \ �������� ������ ������������� �����

#define RSSTART         8  \ ��������� �����
#define RSSTOP          9  \ ��������� �����
#define RSLOAD          10 \ ��������� ����� ��������
#define RSSYN		11 \ ����� ������������ ��� ���������
#define RSLSYM          12 \ ����� ������ ��� ������������ �����
#define RSATTEN 	16 \ �������� ���������� ADC
#define RSDM            17 \ ���������� ����� ��������� ������-����������
#define TRSCRB          18 \ ����� ���������� ����� ����������� �������

#define RSMASK          20 \ �������� ����� �������������
#define CNKPRS 		21 \ �������� ������� ����������� �����
#define ZAPROS		23 \ ������� ������ � HIP
#define TRKOFC          24 \ ����� ����. ����� ��� �����������
#define RSKOFC          25 \ ����� ����. ����� ��� ���������
#define NULLLEV         26 \ �������� min max �������
#define OTSTIP		28 \ ���������� ��� �������
#define OTSLEV		29 \ ���������� ������� �������
#define TRSNRATIO 	30 \ �������� ��������� ���������� ����
#define RSTRECEIVE	45 \ ������� ������������ ���������
#define RSTTRANSMIT	46 \ ������� ������������ �����������
#define ChangeChan      40 \ �������� ������� ����� �����
#define SETDATA 53 \ ���������� ���� ����������������
#define CMYFRIC 54 \ ���������� ����������� �������
#define CINVTR  43 \ ���������� �������� �����������
#define CINVRS  44 \ ���������� �������� ���������
#define MTXCOD  55 \ ���������� �������� �� �� �����
#define MRXCOD  56 \ ���������� �������� �� � �����
#define PUTNCHAN  58 \ ���������� ����� �������� ������


\ ���� HIP ��������
#define RSLEV 		 0 \ ������ ������ ������
#define TIPOTS           1 \ ������ �� ��� ������� ������ �����
#define RSKOFSV          2 \ ������ �� ����. ����� ���������
#define RSKOFAT		 3 \ ������ �� ���������� ADC
#define OTSVOL		 4 \ ������ �� �������� �������
#define NMINLEV		 5 \ ���� ���. �������� ������
#define NMAXLEV		 6 \ ���� ���. �������� ������
#define GETSOSTC         7 \ ���� ������� ��������� ������ �����

#define TRTekSost        8 \ ������ ������� ��������� �����������
#define RsCRC            9 \ ������ ������� ��������� CRC ���������
#define TrCRC           10 \ ������ ������� ��������� CRC �����������
#define SAVEOPT		11 \ ��������� ������� ��������� ����������
#define inKoffTr        12 \ ������ ������� ����������� ����� �����������
#define inUrTr          13 \ ������ ������� ������ ����������
#define inDACkof        14 \ ������ ������� �������� ��������� DAC
#define inDMset         15 \ ������ ����. �������� ���������
#define inCodec         16 \ ������ �������� ��������� �������� ����������� ����
#define BITMOLZAP       17  \ ������ �������� ���� ���������� �����

#define SAVEBOOT 			27 \ ��������� ���������
#define TESTFLASHPRG		28 \ ���������� ������� ����������� ���������
#define GETTMPVAR			29 \ �������� ����� �������� ���������
#define GETNCHAN			30 \ �������� ����� �������� ������ �����

: _2W@ ( adr n - n )
2* + W@
;

: PrnMDate ( un - uy um ud )  { v -- }
v 0x007F AND 
v 0x0780 AND 7 RSHIFT 
v 0xF800 AND 11 RSHIFT 
;
