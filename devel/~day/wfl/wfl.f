0 CONSTANT WFL

REQUIRE WL-MODULES ~day\lib\includemodule.f

REQUIRE CASE   lib/ext/case.f

NEEDS   ~day\hype3\locals.f

MODULE: COM

NEEDS           ~yz/lib/automate.f
NEEDS 		~yz\lib\comevents.f 

EXPORT

: [[ POSTPONE [[ ; IMMEDIATE

;MODULE

NEEDS  ~day\wincons\wc.f
S" ~yz\cons\commctrl.const" ADD-CONST-VOC

NEEDS ~day\lib\unicode.f
NEEDS ~day\hype3\lib\string.f
NEEDS ~day\wfl\lib\wfunc.f
NEEDS ~day\wfl\lib\thunk.f
NEEDS ~day\wfl\lib\menu.f
NEEDS ~day\wfl\lib\misc.f
NEEDS ~day\wfl\lib\gdi.f
NEEDS ~day\wfl\lib\reflection.f

NEEDS ~day\wfl\lib\messageloop.f 

NEEDS ~day\wfl\lib\window.f

NEEDS ~day\wfl\lib\controls.f

NEEDS ~day\wfl\lib\dialogtemplates.f
NEEDS ~day\wfl\lib\dialog.f

NEEDS ~day\wfl\lib\activex.f
NEEDS ~day\wfl\lib\htmlcontrol.f

NEEDS ~day\wfl\lib\commondialogs.f
