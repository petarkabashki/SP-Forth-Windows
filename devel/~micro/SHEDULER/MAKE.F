\ S" newinclude.f" INCLUDED

S" q1.f" INCLUDED

S" ~micro\deleter\interface.f" INCLUDED
S" ~micro\autopush\interface.f" INCLUDED
S" ~micro\filetrunc\interface.f" INCLUDED

REQUIRE WINCONST lib/win/const.f
SW_SHOW CONSTANT SW_SHOW
WINAPI: ShowWindow user32.dll

(
SW_HIDE             CONSTANT   SW_HIDE
SW_MAXIMIZE         CONSTANT   SW_MAXIMIZE
SW_MINIMIZE         CONSTANT   SW_MINIMIZE
SW_RESTORE          CONSTANT   SW_RESTORE
SW_SHOW             CONSTANT   SW_SHOW
SW_SHOWDEFAULT      CONSTANT   SW_SHOWDEFAULT
SW_SHOWMAXIMIZED    CONSTANT   SW_SHOWMAXIMIZED
SW_SHOWMINIMIZED    CONSTANT   SW_SHOWMINIMIZED
SW_SHOWMINNOACTIVE  CONSTANT   SW_SHOWMINNOACTIVE
SW_SHOWNA           CONSTANT   SW_SHOWNA
SW_SHOWNOACTIVATE   CONSTANT   SW_SHOWNOACTIVATE
SW_SHOWNORMAL       CONSTANT   SW_SHOWNORMAL
)

:NONAME
  [ ALSO Sheduler ]
  ALSO Sheduler Interface
  S" sheduler.cfg" INCLUDED
  BEGIN -1 PAUSE AGAIN
; TO <MAIN>
FALSE TO SPF-INIT?
TRUE TO ?GUI
S" shd.exe" SAVE BYE