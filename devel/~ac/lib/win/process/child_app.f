REQUIRE {                     ~ac/lib/locals.f
REQUIRE StartApp              ~ac/lib/win/process/process.f
REQUIRE DUP-HANDLE-INHERITED  ~ac/lib/win/process/pipes.f

USER StdinRH
USER StdinWH
USER StdoutRH
USER StdoutWH
USER StderrRH
USER StderrWH

: HERITABLE-HANDLE ( h1 -- h2 ) \ ~ruv
  DUP DUP-HANDLE-INHERITED THROW SWAP CLOSE-FILE THROW
;
: CreateStdPipes ( -- i o e )
\ ������� ����� ��� �������� ��������� �������� � �������� stdin/out/err
\ � ������� �� ������.
\ ������ ������������ ������ ���� �������� � ����������:
\ StdinWH (���� ������� ��, ��� ������� ����� � stdin),
\ StdoutRH (������ ������ ����� �����)
\ StderrRH (������ ������ ������ �����)

  0 0 StdinWH StdinRH CreatePipe ERR THROW
  0 0 StdoutWH StdoutRH CreatePipe ERR THROW
  0 0 StderrWH StderrRH CreatePipe ERR THROW
  StdinRH @ HERITABLE-HANDLE \ StdInput !
  StdoutWH @ HERITABLE-HANDLE \ StdOutput !
  StderrWH @ HERITABLE-HANDLE \ StdErr !
;

: ChildAppErr ( input-handle output-handle err-handle a u -- p-handle ior )
  { i o e a u \ pi si res }
  5 CELLS      ALLOCATE THROW -> pi   pi 5 CELLS ERASE
  /STARTUPINFO ALLOCATE THROW -> si   si /STARTUPINFO ERASE
  /STARTUPINFO si cb !
  SW_HIDE si wShowWindow !
  STARTF_USESTDHANDLES STARTF_USESHOWWINDOW OR si dwFlags !
  i ( DUP-HANDLE-INHERITED THROW) si hStdInput !
  o ( DUP-HANDLE-INHERITED THROW) si hStdOutput !
  e ( DUP-HANDLE-INHERITED THROW) si hStdError !
  pi
  si
  0 \ cur dir
  0 \ envir
  0    \ creation flags
  TRUE \ inherit handles
  0 0  \ process & thread security
  a    \ command line
  0    \ application
  CreateProcessA ERR -> res
  pi CELL+ @ CLOSE-FILE DROP \ thread handle close
  pi @ \ process handle
 \ pi CELL+ CELL+ @ \ process id
  pi FREE DROP
  i CLOSE-FILE THROW
  o CLOSE-FILE THROW
  res
;
: ChildApp ( input-handle output-handle a u -- p-handle ior )
  2>R DUP 2R> ChildAppErr
;
: ChildAppWaitDir ( input-handle output-handle err-handle S" application.exe" S" curr_directory" wait -- exit_code ior )
\ �� ��, ��� � StartAppWaitDir, �� � ��������� �������
  { i o e a u da du w \ pi si c }
  5 CELLS      ALLOCATE THROW -> pi   pi 5 CELLS ERASE
  /STARTUPINFO ALLOCATE THROW -> si   si /STARTUPINFO ERASE
  /STARTUPINFO si cb !
  SW_HIDE si wShowWindow !
  STARTF_USESTDHANDLES STARTF_USESHOWWINDOW OR si dwFlags !
  i ( DUP-HANDLE-INHERITED THROW) si hStdInput !
  o ( DUP-HANDLE-INHERITED THROW) si hStdOutput !
  e ( DUP-HANDLE-INHERITED THROW) si hStdError !
  pi
  si
  da   \ cur dir
  0    \ envir
  0    \ creation flags
  TRUE \ inherit handles
  0 0  \ process & thread security
  a    \ command line
  0    \ application
  CreateProcessA DUP
  IF SA_WAIT @ pi @ WaitForSingleObject DROP
     ^ c pi @ GetExitCodeProcess DROP
     pi @ CLOSE-FILE DROP \ process handle close
     pi CELL+ @ CLOSE-FILE DROP \ thread handle close
     c
  ELSE 0 THEN
  ( ior exit_code )
  pi FREE DROP si FREE DROP
  SWAP ERR

  i CLOSE-FILE DROP
  o CLOSE-FILE DROP
  e CLOSE-FILE DROP \ �� ������ throw, �.�. ����� ���� ���� � ��� �� �����
;


\EOF
~ac/lib/str5.f

: TEST
  CreateStdPipes S" F:\spf4\spf4.exe" ChildAppErr THROW
  CLOSE-FILE DROP 

  StdoutRH @ PipeLine >R

  S" WORDS" StdinWH @ WRITE-FILE THROW
  CRLF StdinWH @ WRITE-FILE THROW

\ ������ ������� ����� �� ����������� � spf, �.�. READ-LINE ������� ��
\ ������ ������, � �� ������:

  S" 5 5 + ." StdinWH @ WRITE-FILE THROW
  CRLF StdinWH @ WRITE-FILE THROW

  StdinWH @ CLOSE-FILE THROW

  BEGIN
    R@ PipeReadLine ." =>" TYPE ." <=" CR
  AGAIN

  RDROP
  StdoutRH @  CLOSE-FILE THROW
;
' TEST CATCH .

(
REQUIRE fsockopen ~ac/lib/win/winsock/ws2/psocket.f
: TEST { \ s }
  SocketsStartup THROW
  " localhost" 25 fsockopen fsock
  DUP

  S" c:\spf\spf375.exe" ChildApp THROW
  -1 OVER WaitForSingleObject DROP CLOSE-FILE THROW
;
)