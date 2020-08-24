REQUIRE ->" ~micro/autopush/interface.f
REQUIRE WINCONST lib/win/const.f
REQUIRE FindChildByClass ~micro/lib/windows/window.f

MODULE: EDialer
  : EDialerWindow ( -- h )
    S" EType Dialer" DROP S" TForm1" DROP 0 desktop FindWindowExA
  ;
  
  : ReadyForAction ( -- addr u )
    EDialerWindow
    S" TTabbedNotebook" FindChildByClass
    ->" ����������"
    ->" ����������"
    S" TButton" FindChildByClass
    GetWindowText
  ;

  : BreakDial
    EDialerWindow
    S" TTabbedNotebook" FindChildByClass
    ->" ����������"
    ->" ����������"
    ->" ��������"
    push
  ;

  : Disconnect
    EDialerWindow
    S" TTabbedNotebook" FindChildByClass
    ->" ����������"
    ->" ����������"
    ->" ���������"
    push
  ;

  : Connect
    EDialerWindow
    S" TTabbedNotebook" FindChildByClass
    ->" ����������"
    ->" ����������"
    ->" �������"
    push
  ;

  : Reconnect
    EDialerWindow
    S" TTabbedNotebook" FindChildByClass
    ->" ����������"
    DUP
      S" TListBox" FindChildByClass >R
      0x00070007 1 WM_LBUTTONDBLCLK R@ SendMessageA DROP
    0 SWAP S" TListBox" DROP SWAP R> SWAP FindWindowExA >R
    0x00070007 1 WM_LBUTTONDBLCLK R> SendMessageA DROP
  ;
;MODULE