( ����ᥪ�ୠ� ������ ������᪮� �������� ������
  �� �᫮��� �����-�㣫��
  k' = s*a*[k**alpha]-[mju+g]*k
)
VOCABULARY Model4
GET-CURRENT
ALSO Model4 DEFINITIONS

\ ����樥��� ��� ��ࠨ�� �� 1999 �.
0.3e FVALUE alpha 
0.1e FVALUE mju    \ ��ଠ ����⨧�樨
0.1e FVALUE g      \ ����� ��ᥫ���� (������ �������)
2.5e FVALUE a      \ ���� ࠧ���� �������
0.2e FVALUE s      \ ��ଠ ����������
0.8e FVALUE k0     \ ��砫쭮� ���祭�� ����⠫�-���஥����

: limit \ ��樮��ୠ� �窠
 s a F*
 g mju F+
 F/ FLN
 1e 1e alpha F- F/ 
 F* FEXP 
;

: func 
 FSWAP FDROP 
 FDUP 
 FLN alpha F* FEXP s F* a F* FSWAP 
 mju g F+ F* 
 F-
;
: solution FDROP 0e ;
: init
   0.05e FTO step
   60E FTO interval
   0e FTO tn 
   k0 FTO fn
   0e FTO err-norma 
; 
PREVIOUS
SET-CURRENT
