Dim Forth
Dim Result
Set Forth = CreateObject("SPF.Test")

Result = Forth.WORDS()
WScript.Echo Result

Result = Forth.NEGATE(5)
WScript.Echo Result

Result = Forth.TYPE("������, ����!")
WScript.Echo Result

Result = Forth.TYPE("������, ����!", "������, ������!")
WScript.Echo Result

Result = Forth.EVALUATE("R/W CREATE-FILE THROW", "TEST-FILE.TXT")
WScript.Echo Result

Result = Forth.EVALUATE("CREATE TESTVAR")
WScript.Echo Result

Forth.TESTVAR = 777
WScript.Echo Result

WScript.Echo Forth.TESTVAR

Result = Forth.FORTH.WORDS()
