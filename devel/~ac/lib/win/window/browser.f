\ ���������� ������ �������� ����������� ���������� IE
\ ��� ��������� ������ ����������.
\ �������� ����� ( urla urlu ) Browser � BrowserThread.
\ ���� NewBrowserWindow+AtlMainLoop. ��. ������� � �����.

\ ������������� ������ ��� �������� TAB:
\ ��.���� IOleInPlaceActiveObject::TranslateAccelerator
   \ ������������, ��� ���� ��� � TAB'�� ������ �����:
   \ http://www.microsoft.com/0499/faq/faq0499.asp
   \ �� ���� URL MS �������, ���������� ��������� � ������ :)
   \ � ������ ����������� ��� � AtlAx.
\ ������������ � ����������� ������ ~day/wfl.

\ + 07.07.2008 ��� ��� ��������� �������.

\ + 18.07.2008 �� ��������� ������������ � ������������ � ������� ��������
\   �������� ��������; ���������� ���� ����� onkeypress onclick onactivate 
\   ondeactivate onfocusout onhelp onmouseover onmouseout ��� �������������
\   ��������������� ������� � �������� �� ������ � ����������� IHTMLEventObj

\ + 19.07.2008 ���-���� ������� subclassing ['] BR-WND-PROC h WindowSubclass
\   �.�. Windows �� ������ ��������� WM_CLOSE � �������, � ���� �� ��������
\   ������� ���������. � ��� WM_CLOSE ���������� �����������/�������������/
\   �������������� �������� ���� (������ ��������� � ���-��������).

REQUIRE {                lib/ext/locals.f
REQUIRE COMPARE-U        ~ac/lib/string/compare-u.f
REQUIRE Window           ~ac/lib/win/window/window.f
REQUIRE WindowTransp     ~ac/lib/win/window/decor.f
REQUIRE LoadIcon         ~ac/lib/win/window/image.f 
REQUIRE IID_IWebBrowser2 ~ac/lib/win/com/ibrowser.f 
REQUIRE NSTR             ~ac/lib/win/com/variant.f 
REQUIRE EnumConnectionPoints ~ac/lib/win/com/events.f 
REQUIRE IID_IWebBrowserEvents2 ~ac/lib/win/com/browser_events.f 
REQUIRE IID_IHTMLDocument3 ~ac/lib/win/com/ihtmldocument.f 
REQUIRE IID_IHTMLElementCollection ~ac/lib/win/com/ihtmlelement.f 

\ ������ ��� BrowserThread:
REQUIRE STR@             ~ac/lib/str5.f

WINAPI: AtlAxWinInit     ATL.dll
WINAPI: AtlAxGetControl  ATL.dll

VARIABLE BrTransp \ ���� �� ����, �� ������ ������� ������������ ���������
VARIABLE BrEventsHandler \ ���� �� ����, �� ��� ����������� �������� ����������
                         \ ���������� ��� ������� (������ � ��-�������� Browser)
SPF.IWebBrowserEvents2 BrEventsHandler !
VARIABLE BrCreateHidden \ ���� �� ����, �� ���� ��������� ���������

: TranslateBrowserAccelerator { mem iWebBrowser2 \ oleip -- flag }
  \ ������� ��������, �� �������� �� ������� ���������� �������������
  mem CELL+ @ WM_KEYDOWN =
  IF
    ^ oleip IID_IOleInPlaceActiveObject iWebBrowser2 ::QueryInterface 0= oleip 0 <> AND
    IF
      mem oleip ::TranslateAccelerator \ ���������� 1 ��� wm_char'���
                                       \ �������, ������� ����� ������������ ������
    ELSE TRUE THEN
  ELSE TRUE THEN
     \ 1, ���� �� �����������
     \ -1 ��� ���� �� ������� ��������� ��� ������ �� �������
     \ �.�. ����� = true, ���� ����� ���������� � ������� �������
  0= \ ����������� ���� ��� �������� TranslateAcceleratorA
;

: WindowGetMessage { mem wnd -- flag }
\ ����������� ������������� ���������� ����� MessageLoop
\ ��� ����������� WndProc
\ +19.07.2008: ����������� WndProc BR-WND-PROC �������� ���� ��������
  wnd IsWindow
  IF
    0 0 0 mem GetMessageA 0 >
  ELSE FALSE THEN
  DUP IF DEBUG @ 
         IF mem CELL+ @ WM_SYSTIMER <>
            mem CELL+ @ WM_TIMER <> AND
            mem CELL+ @ 0x8002 <> AND
            IF mem 16 DUMP CR THEN
         THEN
      THEN
;

VECT vPreprocessMessage ( msg -- flag )
\ ����������� "������" � ���� �������� ��������� �������
\ ��� ����������/������������� ��-������, �� ��������� �����������.
\ ���� ���������� TRUE, �� ��������� ��������� ������������ � ����� �� ���������.

VECT vContextMenu ( msg -- ) \ ' DROP TO vContextMenu \ �������� ����.����
VECT vMenu ( msg -- )        ' DROP TO vMenu

: PreprocessMessage1 ( msg -- flag )
  DUP CELL+ @ WM_RBUTTONUP =
  IF ['] vContextMenu BEHAVIOR ['] NOOP = IF DROP FALSE EXIT THEN
     \ �� ��������� ��������� ����������� ����.���� �������� � javascript'��
     vContextMenu TRUE
  ELSE DUP CELL+ @ WM_COMMAND =
       IF vMenu TRUE
       ELSE DROP FALSE THEN
  THEN
;
' PreprocessMessage1 TO vPreprocessMessage

: AtlMessageLoop  { wnd iWebBrowser2 \ mem -- }

\ ���� ���������� ��������� �� ���� ���������� ����,
\ com-��������� �������� � ����� ������������� ���� �������� � �������� 
\ ����������. �� ���������� �� ��� ������� ������ (0 � GetMessage), �.�.
\ ����� �� ������������ �������� ���� - ���������� �������.
\ ���� ����� ��������� ���������� ���� - ��. BrowserThread
\ ���� AtlMainLoop ����.

  /MSG ALLOCATE THROW -> mem
  BEGIN
    mem wnd WindowGetMessage
  WHILE
    mem vPreprocessMessage 0=
    IF
      mem iWebBrowser2 TranslateBrowserAccelerator 0=
      IF
        \ ��� ����� ��������� ����� TranslateAccelerator, ���� ���� ���� ����
        mem TranslateMessage DROP
        mem DispatchMessageA DROP
      THEN
    THEN
  REPEAT
  mem FREE THROW
;
VECT vNavigationFrame
:NONAME S" _self" ; TO vNavigationFrame

: Navigate { addr u bro -- res }
  S" " NSTR   \ headers
  0 VT_ARRAY VT_UI1 OR NVAR \ post data
  vNavigationFrame NSTR    \ target frame name
  0 VT_I4 NVAR \ flags

  addr u NSTR bro ::Navigate2
;
VARIABLE AtlInitCnt

: BrowserSetIcon1 { addr u h -- }
\ ����� � ����������� �� ���� �������� ������, �� � stub'� �� ������������
  1 LoadIconResource16 GCL_HICON h SetClassLongA DROP
;
VECT vBrowserSetIcon ' BrowserSetIcon1 TO vBrowserSetIcon

: BrowserSetTitle1 { addr u h -- }
  addr u
  " {s} -- SP-Forth embedded browser" STR@ DROP h SetWindowTextA DROP
;
VECT vBrowserSetTitle ' BrowserSetTitle1 TO vBrowserSetTitle

: BrowserSetMenu1 { addr u h -- }
;
VECT vBrowserSetMenu ' BrowserSetMenu1 TO vBrowserSetMenu

: BrowserInterface { hwnd \ iu bro -- iwebbrowser2 ior }
  ^ iu hwnd AtlAxGetControl DUP 0=
  IF
    DROP
    ^ bro IID_IWebBrowser2 iu ::QueryInterface DUP 0=
    IF
      bro SWAP
    ELSE ." Can't get browser" DUP . 0 SWAP THEN
  ELSE ." AtlAxGetControl error" DUP . 0 SWAP THEN
;
USER uBrowserInterface \ ��� ������ "���� ���� �� �����" ����� ����� �� �������
USER uBrowserWindow

/COM_OBJ \ ��������� �� VTABLE ������ ����������� WebBrowserEvents2, � ��.����.
CELL -- b.BrowserThread
CELL -- b.BrowserWindow
CELL -- b.BrowserInterface
CELL -- b.BrowserMainDocument \ IDispatch, � �������� ����� �������� IHTMLDocument,2,3
CELL -- b.HtmlDoc2
CELL -- b.HtmlDoc3
CELL -- b.HtmlWin2
\ ��������� ����� �������� � ��������
CONSTANT /BROWSER

VECT vOnWindowPosChanged :NONAME 2DROP 2DROP FALSE ; TO vOnWindowPosChanged
VECT vOnClose :NONAME DROP FALSE ; TO vOnClose

: MinimizeOnClose ( wnd -- )
\ ��� ' MinimizeOnClose TO vOnClose ������� �������� ���� ��������
\ � ��� ������������ (�����������)
  >R 0 SC_MINIMIZE WM_SYSCOMMAND R> PostMessageA DROP
;
: (BR-WND-PROC1) { lparam wparam msg wnd \ [ 4 CELLS ] rect -- lresult }

  msg WM_NCDESTROY = IF 0 EXIT THEN \ ������ ��� ��������, ���� �� ����������

  msg WM_CLOSE = IF wnd vOnClose IF FALSE EXIT THEN THEN

  msg WM_WINDOWPOSCHANGED = IF lparam wparam msg wnd vOnWindowPosChanged IF FALSE EXIT THEN THEN

  msg WM_ERASEBKGND = IF
\ �������
\    rect wnd GetClientRect DROP
\    14 ( highlight brush)
\    rect wparam FillRect DROP
\    TRUE EXIT
  THEN

  lparam wparam msg wnd   wnd WindowOrigProc
;
: (BR-WND-PROC)
  ['] (BR-WND-PROC1) CATCH IF 2DROP 2DROP TRUE THEN
;
' (BR-WND-PROC) WNDPROC: BR-WND-PROC

: BrowserWindow { addr u style parent_hwnd \ h bro b -- hwnd }
\ ������� ���� �������� � ��������� URL addr u � ����.
  AtlInitCnt @ 0= IF AtlAxWinInit 0= IF 0x200A EXIT THEN AtlInitCnt 1+! THEN
  0 0 0 parent_hwnd 0 CW_USEDEFAULT 0 CW_USEDEFAULT style addr S" AtlAxWin" DROP 0
  CreateWindowExA -> h
  h 0= IF EXIT THEN

  addr u h vBrowserSetTitle
  addr u h vBrowserSetIcon
  addr u h vBrowserSetMenu
  BrTransp @ ?DUP IF h WindowTransp THEN

  h uBrowserWindow !
  ['] BR-WND-PROC h WindowSubclass

  h BrowserInterface ?DUP IF NIP THROW THEN -> bro
  bro uBrowserInterface !

  BrEventsHandler @ ?DUP
  IF /BROWSER SWAP NewComObj -> b \ � ������������ ������� ���� ���-�� ���� ��������...
     TlsIndex@ b b.BrowserThread !
     h         b b.BrowserWindow !
     bro       b b.BrowserInterface !
     b IID_IWebBrowserEvents2 bro ConnectInterface \ ������� ������� ��������� �������
  THEN
  h
;

: Browser { addr u \ h -- ior }

  addr u WS_OVERLAPPEDWINDOW \ WS_VSCROLL OR \ WS_HSCROLL OR
                             \ ��������� WS_VSCROLL �������� � �������������
                             \ ������� ��������� ������ ���� ����� GCL_HICON h SetClassLongA
                             \ ������?
  0 BrowserWindow -> h
  h 0= IF 0x200B EXIT THEN

  BrCreateHidden @ 0= IF h WindowShow THEN
  h uBrowserInterface @ AtlMessageLoop 0
  h WindowDelete
  0
;
: AtlMainLoop  { hwnd \ mem -- }
\ ���� ���������� �������� � �������� �������� �������� �����.
\ ����� ����������� ����� ��������� ���������� ���� � ����� ������,
\ ������ �� ����������� ����� �������.
\ ����� "�������� ����" hwnd, ����� ������ ��� ���� ����� ������,
\ ����� ����� �����������...

  /MSG ALLOCATE THROW -> mem
  BEGIN
    hwnd IsWindow
    IF
      0 0 0 mem GetMessageA 0 >
    ELSE FALSE THEN
  WHILE
    mem CELL+ @ WM_KEYDOWN =
    IF
      mem @ GA_ROOT OVER GetAncestor BrowserInterface ( i ior )
      IF DROP TRUE
      ELSE mem SWAP TranslateBrowserAccelerator 0= THEN
    ELSE TRUE THEN

    IF
      mem TranslateMessage DROP
      mem DispatchMessageA DROP
    THEN
  REPEAT
  mem FREE THROW
;

: NewBrowserWindow { addr u \ h -- h }
\ C������ ���������� ���� c ����� addr u � ������� ��� �����
\ ��� ���������� ���������. 
\ ����� �������� ���� ���� ����� ��������� ���� AtlMainLoop.
  addr u WS_OVERLAPPEDWINDOW \ WS_VSCROLL OR \ WS_HSCROLL OR
  0 BrowserWindow
  BrCreateHidden @ 0= IF DUP WindowShow THEN
;
:NONAME ( url -- ior )
  STR@ ['] Browser CATCH ?DUP IF NIP NIP THEN
; TASK: (BrowserThread)

: BrowserThread ( addr u -- )
\ ������ �������� � ��������� ������.
  >STR (BrowserThread) START DROP
;
:NONAME ( url -- ior )
  STR@ ['] Browser CATCH ?DUP IF NIP NIP THEN
  BYE
; TASK: (BrowserMainThread)

: BrowserMainThread ( addr u -- )
\ ������ �������� � ��������� ������.
\ ��� �������� ��� ���� ��������� ����������.
  >STR (BrowserMainThread) START DROP
;

\ ���������� ��� ���������� �������� ��������� ���������
\ ��� ���������� ������������ �������������� ���������
\ oid ����� - ��������� �� ��������� /BROWSER (����), �.�. ��������� ������ SPF.IWebBrowserEvents2
VECT vOnDocumentComplete ( urla urlu obj -- )
:NONAME DROP 2DROP ; TO vOnDocumentComplete

\ ���������� ����� ������������� ����/���������, �� �� ���������� ��������
\ (� �� OnDocumentComplete, ������� ����� ��������)
VECT vOnNavigateComplete ( urla urlu obj -- )
:NONAME DROP 2DROP ; TO vOnNavigateComplete

\ ������������� ��������� ����������� ������� �� ��������:

GET-CURRENT SPF.IWebBrowserEvents2 SpfClassWid SET-CURRENT

ID: DISPID_DOCUMENTCOMPLETE 259 { urla urlu bro \ obj tls doc doc2 doc3 win2 elcol el b boo -- }
    \ =onload
    COM-DEBUG @ IF ." @DocumentComplete! doc=" bro . THEN \ IWebBrowser2 ������������ ������
    uOID @ -> obj
    TlsIndex@ -> tls
    obj b.BrowserThread @ TlsIndex!
    obj uOID !
    bro uBrowserInterface @ = 
    IF \ ���� �������� �������� ������, �� ��� DocumentComplete ��������� ��� ����� �������� �������
       ^ doc bro ::get_Document DROP \ ��������� ������� �� ������ ��������
\       doc . CR
       doc obj b.BrowserMainDocument !
       ^ doc3 IID_IHTMLDocument3 doc ::QueryInterface 0= doc3 0 <> AND
       IF doc3 obj b.HtmlDoc3 !
\ �������:
\         ^ elcol S" DIV" >BSTR doc3 ::getElementsByTagName . elcol . CR
\         ^ len elcol ::get_length . ." len=" len . CR

\ �������� ::item ����� ���������
\         ^ el  0 0 0 VT_I4  0 S" login-form" >BSTR 0 VT_BSTR
\         elcol ::item . el . 
\         3 VT_I4 1 S" item" elcol CNEXEC -> el
\         S" login-form" >VBSTR 1 S" item" elcol CNEXEC -> el
\         el IF
\            ^ el IID_IHTMLElement el ::QueryInterface THROW \ �.�. item ���������� ���-�� ������
\            S" innerText" el CP@ TYPE CR

\ ������������ � ��������  ���������� ��������
\            obj VT_DISPATCH 1 S" onkeypress" el CP!
\            0 obj 0 VT_DISPATCH el ::put_onkeypress THROW
\            THEN
\ ��� ����� ��������� (http://msdn.microsoft.com/en-us/library/ms533051(VS.85).aspx)
            ^ boo obj S" onkeypress" >BSTR doc3 ::attachEvent THROW
            ^ boo obj S" onclick" >BSTR doc3 ::attachEvent THROW
            ^ boo obj S" onactivate" >BSTR doc3 ::attachEvent THROW
            ^ boo obj S" ondeactivate" >BSTR doc3 ::attachEvent THROW
            ^ boo obj S" onfocusout" >BSTR doc3 ::attachEvent THROW
            ^ boo obj S" onhelp" >BSTR doc3 ::attachEvent THROW
            ^ boo obj S" onmouseover" >BSTR doc3 ::attachEvent THROW
            ^ boo obj S" onmouseout" >BSTR doc3 ::attachEvent THROW

\            ^ boo obj S" onblur" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" oncontextmenu" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" oncopy" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" ondrop" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" onerror" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" onfocus" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" onmouseenter" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" onmouseleave" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" onsubmit" >BSTR doc3 ::attachEvent THROW \ �� ��������
\            ^ boo obj S" onunload" >BSTR doc3 ::attachEvent THROW \ �� ��������
       THEN

       ^ doc2 IID_IHTMLDocument2 doc ::QueryInterface 0= doc2 0 <> AND
       IF doc2 obj b.HtmlDoc2 !
          ^ win2 doc2 ::get_parentWindow DROP
          win2 obj b.HtmlWin2 !
       THEN

\       ^ disp IID_DispHTMLDocument doc ::QueryInterface 0= disp 0 <> AND
\       IF ." ---" THEN

       doc2 IF
\ �������, ������ �������� ����� ���������:
\         uCRes doc2 ::get_title THROW uCRes @ UASCIIZ> UNICODE> TYPE CR
\         S" title" doc2 CP@ TYPE CR
\         S" New TITLE" >BSTR doc2 ::put_title THROW
\         S" New TITLE" >VBSTR 1 S" title" doc2 CP!
\         S" <H1>TEST</H1>" >SARR doc2 ::write ." wr=" .
\         S" <H1>TEST</H1>" >VBSTR 1 S" write" doc2 CNEXEC .

\ � ����������:
\          doc S" title" doc2 CP@
\          " {s} (�������� doc={n})" STR@ >BSTR doc2 ::put_title THROW
       THEN
       urla urlu obj vOnDocumentComplete
    THEN
    COM-DEBUG @ IF urla urlu TYPE CR THEN
    tls TlsIndex!
;
ID: DISPID_NAVIGATECOMPLETE2    252 { urla urlu bro \ obj tls doc doc2 doc3 win2 elcol el b boo -- }
    \ ���������� ����� ������������� ����/���������, �� �� ���������� ��������,
    \ ����� ����� ��������� ����������� onerror
    COM-DEBUG @ IF ." @NavigateComplete2! win/frame=" bro . urla urlu TYPE CR THEN
    uOID @ -> obj
    TlsIndex@ -> tls
    obj b.BrowserThread @ TlsIndex!
\ ����� ������� ���������� ��� ���� �������
\    bro uBrowserInterface @ = 
\    IF 
       ^ doc bro ::get_Document DROP
       ^ doc3 IID_IHTMLDocument3 doc ::QueryInterface 0= doc3 0 <> AND
       IF doc3 obj b.HtmlDoc3 !
          ^ boo obj S" onerror" >BSTR doc3 ::attachEvent THROW
          \ � ������� IHTMLDocument3::onerror �� ����������� (?)
       THEN

       ^ doc2 IID_IHTMLDocument2 doc ::QueryInterface 0= doc2 0 <> AND
       IF doc2 obj b.HtmlDoc2 !
          ^ win2 doc2 ::get_parentWindow DROP
          win2 obj b.HtmlWin2 !
          obj VT_DISPATCH 1 S" onerror" win2 CP!
          \ ���������� ��� ������� � ��������
       THEN
\    THEN
       urla urlu obj vOnNavigateComplete
    tls TlsIndex!
;

ID: DISPID_STATUSTEXTCHANGE   102 ( addr u -- )
    COM-DEBUG @ IF ." @StatusTextChange:" TYPE CR ELSE 2DROP THEN
;
ID: DISPID_TITLECHANGE    113  ( addr u -- )
    \ sent when the document title changes
    COM-DEBUG @ IF ." @Title:" 2DUP TYPE CR THEN
    uOID @ b.BrowserWindow @ ?DUP IF vBrowserSetTitle ELSE 2DROP THEN
;
ID: BR_EVENT 0 ( ... -- ) { \ e el }
    COM-DEBUG @ IF ." BR_EVENT:" uOID @ . uOID @ b.HtmlWin2 @ . CR THEN
    S" event" uOID @ b.HtmlWin2 @ CP@ -> e
    e 0= IF DropXtParams EXIT THEN
    COM-DEBUG @ IF 
      S" type" e CP@ 
      ." EVENT=" TYPE SPACE
      S" keyCode" e CP@ ." keyCode=" .
      S" srcElement" e CP@ -> el
      ." srcElement=" el .
      el IF
        S" tagName" el CP@ TYPE SPACE S" id" el CP@ TYPE SPACE S" className" el CP@ TYPE CR
\      S" innerHTML" el CP@ TYPE CR
      THEN
    THEN
    S" type" e CP@ SFIND IF e SWAP EXECUTE
                         ELSE 2DROP DropXtParams THEN
;
SET-CURRENT

\ �������� �������

: GetSiteShortcutIcon { obj \ doc3 elcol len el -- icona iconu }
\ �������� url ������ �����; 
\ ���������� ��� url, ������� � <link rel='shortcut icon'...>,
\ �.�. ����� ���� �� ������ url'��
  obj b.HtmlDoc3 @ -> doc3
  ^ elcol S" LINK" >BSTR doc3 ::getElementsByTagName THROW
  ^ len elcol ::get_length THROW
  S" /favicon.ico"
  len 0 ?DO
         ^ el  0 I 0 VT_I4  0 I 0 VT_I4
         elcol ::item THROW
         S" rel" el CP@ S" shortcut icon" COMPARE-U 0=
         IF S" href" el CP@ 2SWAP 2DROP LEAVE
         THEN
  LOOP
;
: GetSiteIconUrl { urla urlu obj -- urla1 urlu1 }
\ �������� ������ URL ������ f�vicon.ico
  obj GetSiteShortcutIcon
  S" http://" SEARCH 0=
  IF
    OVER C@ [CHAR] / =
    IF \ S" domain" obj b.HtmlDoc2 @ CP@ " http://{s}{s}"
       S" URL" obj b.HtmlDoc2 @ CP@ CUT-PATH 1- " {s}{s}"
    ELSE \ ������������� ����
      urla urlu CUT-PATH " {s}{s}"
    THEN STR@
  THEN
;
WINAPI: URLDownloadToCacheFileA URLMON.DLL

: LoadFile { addr u \ mem -- filea fileu ior }
\ ������� curl'����� GET-FILE ���, ��� ����� ����� �� ��������� ����,
\ ������� ����� ������������ � LoadIcon.
\ � �� ����� �������� ���������� � ������.
  1000 ALLOCATE THROW -> mem
  0 0 1000 mem addr 0 URLDownloadToCacheFileA ?DUP 
  IF S" " ROT mem FREE THROW EXIT THEN
  mem ASCIIZ> 0
;
: SetIconOnDocumentComplete { urla urlu obj \ fa fu -- }
  urla urlu obj GetSiteIconUrl

  LoadFile 0=
  IF 2DUP -> fu -> fa LoadIcon ?DUP
     IF
       GCL_HICON obj b.BrowserWindow @ SetClassLongA DROP
\       S" title" obj b.HtmlDoc2 @ CP@
\       fa fu AgentIconID IconData hWnd @ TrayIconModify
     THEN
  ELSE 2DROP THEN
;
: error ( sMsg,sUrl,sLine -- ) { e -- } \ ��. BR_EVENT ����
  ." Window.error= " TYPE ."  at " TYPE ."  line=" . CR
  TRUE VT_BOOL 1 S" returnValue" e CP! \ �� �������� � ���� ���� ������ IE
;

\EOF
\ ��� ���� �� ��������� �������� �����, �������� ���� �� ����.
\ TRUE COM-DEBUG !

' MinimizeOnClose TO vOnClose
' SetIconOnDocumentComplete TO vOnDocumentComplete

: keypress { ev e -- } \ ��. BR_EVENT ����
  S" keyCode" e CP@ ." keyCode=" .
  S" title" uOID @ b.HtmlDoc2 @ CP@ TYPE CR
;

S" http://127.0.0.1:89/index.html" BrowserThread
S" http://127.0.0.1:89/email/" BrowserThread

\EOF
\ ������ ��������� ���������� ����������������� ���������� ���� ����� ������.
\ ���� ������� ���� � ��� �������������� ����������� "���������" ����� ���.
: TEST1 { \ h }
  S" http://127.0.0.1:89/index.html" NewBrowserWindow -> h
  128 BrTransp !
  S" http://127.0.0.1:89/email/" 0 h BrowserWindow
     DUP 500 400 ROT WindowSize DUP 90 90 ROT WindowRC WindowShow
  S" http://127.0.0.1:89/chat/" WS_OVERLAPPEDWINDOW h BrowserWindow
     DUP 300 300 ROT WindowSize WindowShow
  h AtlMainLoop
  ." done"
; TEST1
