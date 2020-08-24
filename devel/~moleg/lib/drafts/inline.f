\ 03-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ inline ����������� ���� ��� ������ ���� (��������)

 REQUIRE ALIAS   devel\~moleg\lib\util\alias.f
 REQUIRE COMPILE devel\~moleg\lib\util\compile.f
 REQUIRE STREAM{ devel\~moleg\lib\arrays\stream.f

\ ------------------------------------------------------------------------------

 ALIAS : ::
 ALIAS ; ;; IMMEDIATE

VOCABULARY INLINE  \ � ���� ������� ����� ��� ���������

\ ��������������� ':' � ';' ���� ���������� ���� �� ������������� '[' � ']'
\ ������, ��� ����� ����� ������ ��� ����, ���� �������� ���� ��� �����������,
\ ��� ������, ��� ����� '[' � ']' ������ ����������� �� ����� ������������
:: : ( --> ) ALSO INLINE [COMPILE] : ;;
:: ; ( --> ) PREVIOUS    [COMPILE] ; ;; IMMEDIATE

\ �������� �������� ������� ��� ������ �����������
: inline{  ( | name hex-stream --> )
          ALSO INLINE DEFINITIONS
          : [COMPILE] STREAM{ ;

\ ��������� hex-stream ����� � ��������� �������� �������
\ ����� inline ����������� ������ ������ ������ } ���������� ������
\ ������ ����� �������� '}' � ������ inline �� ����������
: inline ( asc # --> )
         SLIT, COMPILE S,
         [COMPILE] ; IMMEDIATE
         PREVIOUS DEFINITIONS
         ; IMMEDIATE

\ ------------------------------------------------------------------------------
\ ������� �������� ��� inline �����������
inline{ DUP   8D6DFC 894500 }inline
inline{ DROP  8B4599 8D6D04 }inline
inline{ SWAP  8B5500 894500 8BC2 }inline
inline{ OVER  8D6DFC 894500 8B4504 }inline
inline{ NIP   8D6D04 }inline
inline{ TUCK  8D6DFC 8B5504 894504 895500 }inline
inline{ ROT   8B5500 894500 8B4504 895504 }inline
inline{ RDROP 5B 8D642404 }inline

?DEFINED test{ \EOF -- �������� ������ -----------------------------------------

test{ : proba OVER OVER ; 1 2 proba D= 1 + THROW
  S" passed" TYPE
}test
