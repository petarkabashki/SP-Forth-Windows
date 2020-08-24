\ 24-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ �������������� ������ ����� � �������� �������������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE SkipChar devel\~mOleg\lib\util\parser.f
 REQUIRE >CIPHER  devel\~moleg\lib\parsing\number.f
 REQUIRE bPlus    devel\~moleg\lib\arrays\barray.f

        USER-VALUE bit-size \ ������� ��� �������� ���� ������
        USER-VALUE max-char \ ����������� ���������� �������� �������� �������

\ ���������� ������� ����� � PAD
: |bbuf ( --> )
        SYSTEM-PAD DUP barray ! PAD OVER - ERASE
        0 retain ! ;

\ ������� ����� ������ �������� ������� � ��� ����� � ������
: bbuf> ( --> addr # )
        barray @ retain @ bits/addr
        /MOD SWAP 0<> NEGATE + ;

\ ���������� ��� ������
: stream-type ( --> )
              SkipDelimiters PeekChar
              \ �����������������
              [CHAR] x OVER = OVER [CHAR] X = OR
                     IF DROP SkipChar 4 TO bit-size 0x10 TO max-char EXIT THEN
              \ ������������
              [CHAR] o OVER = OVER [CHAR] O = OR
                     IF DROP SkipChar 3 TO bit-size 0x8 TO max-char EXIT THEN
              \ ��������
              [CHAR] b OVER = OVER [CHAR] B = OR
                     IF DROP SkipChar 1 TO bit-size 0x2 TO max-char EXIT THEN

              \ �� ��������� 16������ �����
              DROP 4 TO bit-size 0x10 TO max-char
              ;

\ ��������� ������� ����� �� ����������� ������ '}' ��� ']'
: parse-stream ( --> )
               BEGIN SkipDelimiters GetChar WHILE \ �� �������� ������� �����
                     >CIPHER DUP 0 max-char WITHIN WHILE \ ���������� �������
                     bit-size bPlus
                     SkipChar
                  REPEAT \ �������� ����������� ������
                     PeekChar [CHAR] } = PeekChar [CHAR] ] = OR
                     IF SkipChar DROP EXIT THEN
               THEN DROP -1 THROW ;

\ ������� ����� ���������������� ������ � �������� �������������
: STREAM{ ( /stream} --> addr # )
          |bbuf stream-type
                ['] parse-stream CATCH THROW
          bbuf> ;

\ ������������� ����� � ������� �����������
: STREAM[ ( /stream --> ) STREAM{ S, ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ STREAM{ FAD3C5EB} DROP @ 0xEBC5D3FA <> THROW
      STREAM{ o1234560} DROP @ 0x80CB29 <> THROW
      STREAM{ b1110 1010 1101 0101 0101 0111 } DROP @ 0x57D5EA <> THROW
  S" passed" TYPE
}test



