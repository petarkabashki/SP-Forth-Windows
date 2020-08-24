: nSTR
( 0 addr u -- addr u -1 )
( n addr u -- n-1 )
	ROT DUP IF
		NIP NIP
	THEN
	1- ;

MODULE: Propis

\ genders

0 CONSTANT neuter
1 CONSTANT male
2 CONSTANT female

: trans-0-9-male ( n -- addr u )
	S" ����" nSTR
	S" ����" nSTR
	S" ���" nSTR
	S" ��" nSTR
	S" ����" nSTR
	S" ����" nSTR
	S" ����" nSTR
	S" ᥬ�" nSTR
	S" ��ᥬ�" nSTR
	S" ������" nSTR
	DROP
;

: trans-0-9-female ( n -- addr u )
	DUP 1 = OVER 2 = OR IF
		1-
		S" ����" nSTR
		S" ���" nSTR
		DROP
	ELSE
		trans-0-9-male
	THEN ;

: trans-0-9-neuter ( n -- addr u )
	DUP 1 = IF
		DROP
		S" ����"
	ELSE
		trans-0-9-male
	THEN ;

: trans-0-9 ( n gender -- addr u )
	DUP male = IF
		DROP trans-0-9-male
	ELSE
		female = IF
			trans-0-9-female
		ELSE
			trans-0-9-neuter
		THEN
	THEN ;

: trans-10-19-any ( n -- addr u )
	10 -
	S" ������" nSTR
	S" ����������" nSTR
	S" ���������" nSTR
	S" �ਭ�����" nSTR
	S" ���ୠ����" nSTR
	S" ��⭠����" nSTR
	S" ��⭠����" nSTR
	S" ᥬ������" nSTR
	S" ��ᥬ������" nSTR
	S" ����⭠����" nSTR
	DROP
;

: trans-tens-2-9-any ( n -- addr u )
	2 -
	S" �������" nSTR
	S" �ਤ���" nSTR
	S" �ப" nSTR
	S" ���줥���" nSTR
	S" ���줥���" nSTR
	S" ᥬ줥���" nSTR
	S" ��ᥬ줥���" nSTR
	S" ���ﭮ��" nSTR
	DROP
;

: #trans-0-9
	trans-0-9 HOLDS ;

: #try-trans-less-number-by ( n genre max xt -- n1 )
	>R
	SWAP >R
	/MOD SWAP ( n/max n_mod_max )
	DUP IF
		R> R> EXECUTE
		BL HOLD
	ELSE
		DROP RDROP RDROP
	THEN
;

: #trans-0-99 ( n gender -- )
	OVER 10 < IF
		trans-0-9 HOLDS
	ELSE
		OVER 20 < IF
			DROP trans-10-19-any HOLDS
		ELSE
			10 ['] #trans-0-9 #try-trans-less-number-by
			trans-tens-2-9-any HOLDS
		THEN
	THEN
;

: trans-hundreds-1-9-any ( n -- addr u )
	1-
	S" ��" nSTR
	S" �����" nSTR
	S" ����" nSTR
	S" ������" nSTR
	S" ������" nSTR
	S" ������" nSTR
	S" ᥬ���" nSTR
	S" ��ᥬ��" nSTR
	S" ��������" nSTR
	DROP
;	

: #trans-0-999 ( n genre -- )
	OVER 100 < IF
		#trans-0-99
    ELSE
    	100 ['] #trans-0-99 #try-trans-less-number-by
    	trans-hundreds-1-9-any HOLDS
    THEN
;

: number-of ( n -- 0 | 1 | 2 )
	DUP 10 / 10 MOD 1 = IF
		DROP 0
	ELSE
		10 MOD
		DUP 0= IF
			DROP 0
		ELSE
			DUP 1 = IF
				DROP 1
			ELSE
				5 < IF
					2
			    ELSE
			    	0
			    THEN
			THEN
		THEN
	THEN
;

: #trans-million ( n genre -- )
	OVER 1000 < IF
		#trans-0-999
	ELSE
		1000 ['] #trans-0-999 #try-trans-less-number-by
		DUP number-of
			S" �����" nSTR
			S" �����" nSTR
			S" �����" nSTR
			DROP
		HOLDS
		BL HOLD
		female #trans-0-999
	THEN
;

: #trans-billion ( n genre -- )
	OVER 1000000 < IF
		#trans-million
	ELSE
		1000000 ['] #trans-million #try-trans-less-number-by
		DUP number-of
			S" ���������" nSTR
			S" �������" nSTR
			S" ��������" nSTR
			DROP
		HOLDS
		BL HOLD
		male #trans-0-999 
	THEN
;

\ ���ᨬ��쭮� 32��⭮� �᫮ 2147483647
\ 2 147 483 647
\    |   |
\    |   �����
\    ���������

\ ���ᨬ��쭮� 64��⭮� �᫮ 9223372036854775807
\ 9 223 372 036 854 775 807
\    |   |   |   |   |
\    |   |   |   |   �����
\    |   |   |   ���������
\    |   |   ������म�
\    |   �ਫ������
\    ����ਫ������

: mlrd-UM/MOD ( d n -- quotient remainder[d] )
	>R
	1000000000 UM/MOD ( d_mod_mlrd d/mlrd )
	R> /MOD SWAP ( d_mod_mlrd [d/mlrd]_mod_n [d/mlrd]/n )
	ROT S>D ( [d/mlrd]/n [d/mlrd]_mod_n d_mod_mlrd[d] )
	ROT 1000000000 UM*
	D+
;

: #D-try-trans-less-number-by ( d gender max-mlrds xt -- n1 )
	>R
	SWAP >R
	mlrd-UM/MOD
	2DUP OR IF
		R> R> EXECUTE
		BL HOLD
	ELSE
		2DROP RDROP RDROP
	THEN
;

: #D-trans-billion ( d genre -- )
	>R D>S R> #trans-billion
;

: D-number-of ( d -- 0 | 1 | 2 )
	1000000000 UM/MOD DROP number-of
;

: #trans-trillion ( d genre -- )
	>R
	2DUP 1000000000. D< IF
		D>S R> #trans-billion
	ELSE
		R> 1 ['] #D-trans-billion #D-try-trans-less-number-by
		DUP number-of
			S" ������म�" nSTR
			S" �������" nSTR
			S" ������ठ" nSTR
			DROP
		HOLDS
		BL HOLD
		male #trans-0-999
	THEN 
;

: #trans-quadrillion ( d genre -- )
	>R
	2DUP 1000000000000. D< IF
		R> #trans-trillion
	ELSE
		R> 1000 ['] #trans-trillion #D-try-trans-less-number-by
		DUP number-of
			S" �ਫ������" nSTR
			S" �ਫ����" nSTR
			S" �ਫ�����" nSTR
			DROP
	    HOLDS
	    BL HOLD
	    male #trans-0-999
	THEN
;

: #trans ( d genre -- )
	>R
	2DUP 1000000000000000. D< IF
		R> #trans-quadrillion
	ELSE
		R> 1000000 ['] #trans-quadrillion #D-try-trans-less-number-by
		DUP number-of
			S" ����ਫ������" nSTR
			S" ����ਫ����" nSTR
			S" ����ਫ�����" nSTR
			DROP
	    HOLDS
	    BL HOLD
	    male #trans-0-999
	THEN
;

;MODULE

\ \EOF

\ �� P100:
\ �᫮                 ��ॢ���� � ᥪ㭤�
\ 999999999999999999     4000
\ 100000000000000000    45000
\                  1   166000

ALSO Propis

: q
	1000000 0 DO
		I 1000000000 UM* I S>D D+ I 35846 UM* D+
		2DUP D.
		2DUP <# female #trans 0. #> TYPE ."  "
		D-number-of
			S" ����� ��஭" nSTR
			S" ����� ��஭�" nSTR
			S" ���� ��஭�" nSTR
			DROP
		TYPE CR
		KEY DROP
	LOOP
;

