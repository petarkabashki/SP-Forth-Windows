\ ��������� ������: �������� �� ����� �������� 
\ ���� � ������ ������ �� ������ ������� ���������
\ �������������.
\ (��-��!.. � �� ����� �� ����� ��� 
\ lib/ext/disasm.f -- ��� ������� � ����� �����������?..)

\ ��� ���� ������������ ����������������� ������/�����
\ � ����������� ���������� ������������� � ���� �������

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE DISASSEMBLER lib/ext/disasm.f

{{ DISASSEMBLER

MODULE: move-code

: REL16/32 ( ADDR OP -- ADDR' )
        16-BIT-ADDR
        IF      W@+
        ELSE    @+
        THEN    OVER + BASE-ADDR - >MAX_R 
( jmp-addr addr )
\ ['] TYPE1 TO TYPE \ ��� �������, ���� �� ����� ������ ������ references �������� �����
OVER CELL- OVER CONT 2DROP
                          \ DUP ." {" BASE @ SWAP HEX . BASE ! ."  | " OVER BASE @ SWAP HEX . BASE ! ." }" 
\ ['] 2DROP TO TYPE
DROP \ SHOW-NAME \ ����� ������ ��� �������� � ������� ���� �� ����� �� ����� ����������?..
;

: JSR  ( ADDR OP -- ADDR' )
        .S" CALL    " DROP REL16/32 ; \ E8

: JMP  ( ADDR OP -- ADDR' )
        .S" JMP     " 2 AND IF REL8 ELSE REL16/32 THEN ; \ E9

EXPORT

\ �������� ������
: references=> ( xt end --> jump place / <-- jump place ) PRO

\ ��������� ������������ ������� �� ���. ������� ������������
\ � 0xE8 � 0xE9 �� "����" �����
['] JSR OP-TABLE 0xE8 CELLS + KEEP!
['] JMP OP-TABLE 0xE9 CELLS + KEEP!

\ ��������� ���������� ������/����� �������������
['] 2DROP ['] TYPE CFL + KEEP!
['] BL ['] KEY CFL + KEEP!
REST-AREA ;

USER delta

\ ����������� ���� ������
: correct-jumps ( xt end start -- ) delta KEEP
SWAP >R OVER - delta ! R>
references=> OVER delta @ + delta @ NEGATE SWAP +! ;

: COPY-CODE-END ( xt end -- ) \ ����������� � �������� ���� ������� � xt �� ������ end
OVER 2DUP - ( xt end xt len ) HERE DUP >R SWAP DUP ALLOT CMOVE
( xt end ) R> correct-jumps ;

: COPY-CODE ( xt -- )
DUP FIND-REST-END
3 + ( it's a kind of magic... )
COPY-CODE-END ;

: DUPLICATE ' NextWord SHEADER COPY-CODE RET, ;

;MODULE

}}

/TEST

: source
10 DUP *
HERE
10 0 DO I LOOP
S" str" OVER + SWAP DO I C@ LOOP ;

: destination [ ' source COPY-CODE ] ;

DUPLICATE DP DP1

REQUIRE TESTCASES ~ygrek/lib/testcase.f

TESTCASES code copying
(( source       -> 10 DUP * HERE 0 1 2 3 4 5 6 7 8 9 CHAR s CHAR t CHAR r ))
(( destination  -> 10 DUP * HERE 0 1 2 3 4 5 6 7 8 9 CHAR s CHAR t CHAR r ))
(( DP1 -> DP ))
END-TESTCASES

\ SEE source  SEE destination

\EOF




\ ���������������� (��������������?) ���������� �� lib/ext/disasm.f :

: CIS   ( ADDR OP -- ADDR' )
        0x9A =
        IF      .S" CALL    "
        ELSE    .S" JMP     "
        THEN
        16-BIT-DATA
        IF      .S" PTR16:16 "
        ELSE    .S" PTR16:32 "
        THEN
        COUNT MOD-R/M ; \ EA


: FF.  ( ADDR OP -- ADDR' )
        DROP COUNT
        DUP 3 RSHIFT 7 AND
        CASE
                0 OF .S" INC     "      ENDOF
                1 OF .S" DEC     "      ENDOF
                2 OF .S" CALL    "      ENDOF
                3 OF .S" CALL    FAR "  ENDOF
                4 OF .S" JMP     "      ENDOF
                5 OF .S" JMP     FAR "  ENDOF
                6 OF .S" PUSH    "      ENDOF
                     .S" ???     "
        ENDCASE R/M16/32 ; \ FF