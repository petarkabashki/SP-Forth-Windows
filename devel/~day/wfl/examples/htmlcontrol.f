( Simple activeX hosting example in dialog! )

REQUIRE WL-MODULES ~day\lib\includemodule.f
NEEDS ~day\wfl\wfl.f

101 CONSTANT leftCtlID
102 CONSTANT rightCtlID

CDialog SUBCLASS CHtmlDialog

	CWebBrowser OBJ ctl 
	CWebBrowser OBJ ctl2

W: WM_INITDIALOG ( -- n )
   \ file system
   ctl className leftCtlID SUPER getDlgItem ctl attach
   S" c:\" ctl navigate
  
   \ web site
   ctl className rightCtlID SUPER getDlgItem ctl2 attach
   S" http://forth.org.ru" ctl2 navigate

  TRUE
;

;CLASS

0 0 410 300
WS_POPUP WS_SYSMENU OR WS_CAPTION OR DS_MODALFRAME OR
DS_CENTER OR

DIALOG: HTMLDialog ActiveX hosting example in dialog!
      leftCtlID   2 2 200 297   0 LTEXT
      rightCtlID  205 2 200 297 0 LTEXT
DIALOG;

: winTest ( -- n )
  || CHtmlDialog dlg ||

  StartCOM

  HTMLDialog 0 dlg showModal

  EndCOM
;

winTest