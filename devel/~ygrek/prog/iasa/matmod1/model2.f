( ������ ��� ��த���ᥫ���� �������
  N'=mju*N*[K-N]
)
VOCABULARY Model2
GET-CURRENT
ALSO Model2 DEFINITIONS

 0.02e FVALUE mju    \ ����� ABS(mju)<=1
  120e FVALUE K      \ ���������� �।�
   10e FVALUE N0     \ ��砫쭮� ���祭�� ��ᥫ����
: limit  K ; \ ��樮��ୠ� �窠

: func
  FSWAP FDROP
  FDUP FNEGATE K F+
  F* 
  mju F*
;
: solution FDROP 0e ; 
: init
   0.01e FTO step
   3E FTO interval
   0e FTO tn 
   N0 FTO fn 
   0e FTO err-norma 
;

PREVIOUS
SET-CURRENT