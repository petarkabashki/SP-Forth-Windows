\ 20.Jan.2004     ~ruv

( ���������� SPF
    ������� ����/�����  �� ���� �����������.

  �������������� ��� ����������� ����� ������ � �������
  [��������� ���������� stream_io_impl.f],
  �������������� �������� �������� ����� ������� OLD-IO

  �����������:
    - ��������� �� ������ ��������, ��� SOURCE-ID == WinKernel Handle
    - � ��������, ������������� SOURCE-ID
      ����� ��������� ������ ����� �������� ������� SPF
)
\ �������� �������� ������� (INCLUDED)
\ ������ � ������� FStreamSupport

VOCABULARY OLD-IO   ALSO OLD-IO   FORTH-WORDLIST @  CONTEXT @ ! PREVIOUS

REQUIRE FStreamSupport  ~pinka\samples\2004\spf\FStream\stream_io_impl.f

WARNING @ WARNING 0!

: RECEIVE-WITH  ( i*x source xt -- j*x ior )
  ['] READ-LINE SWAP RECEIVE-WITH-XT
;
: INCLUDE-FILE ( i*x fileid -- j*x ) \ 94 FILE
  BLK 0!  DUP >R  
  ['] TranslateFlow RECEIVE-WITH
  R> CLOSE-FILE THROW
  THROW
;
: (INCLUDED2) ( i*x a u -- j*x )
  R/O OPEN-FILE-SHARED THROW
  INCLUDE-FILE
;
' (INCLUDED2) TO (INCLUDED)

WARNING !
