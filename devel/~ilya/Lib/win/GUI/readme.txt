��� ���������  GUI ��� �� ~nn ��������� ��������� �������:
1) �� win32forth (http://www.win32forth.org/) ���� wincon.dll
2) ��������� � spf4.ini
				REQUIRE UseDLL  ~NN\LIB\USEDLL.F 
				REQUIRE (WINAPI:) ~nn/lib/winapi.f
				REQUIRE LH-INCLUDED  ~nn/lib/lh.f
				S" ~nn/lib/wincon.f"  LH-INCLUDED
				UseDLL USER32.DLL
				UseDLL KERNEL32.DLL
				UseDLL GDI32.DLL

�������� !
