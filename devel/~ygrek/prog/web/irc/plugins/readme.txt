\ $Id: readme.txt,v 1.1 2007/07/18 18:49:53 ygreks Exp $

������� BOT-COMMANDS �������� ��� ������� ������� ����� ������������ ���.
������ ��������� - ������ ��������� IRC �������� � ��������� ����� �������
��������� ��� ����� �������. ���� ����� ������� - ��� �����������. ���� ���������
�������� ��� ������� �����, �.�. ����� PARSE-��� � �������������. ��� �����
������� ��� � ���� ������� ��������� ���������.
����� ������� ��� ���� ����� �������� ������� �� ������� !say :

MODULE: BOT-COMMANDS \ ����� ��������� ����� � ������� BOT-COMMANDS

: !say
   0 PARSE \ �������� �� ���������
   FINE-HEAD FINE-TAIL \ ������ ������� � ������ � � ������
   ?DUP IF DROP S" ��� �������?" THEN \ ����� �� ��������� �� ������ ������
   S-REPLY \ ��������
   ;
   
;MODULE \ ��������� �������

��������� �����-�� �������� ��� �������� � ������� ����� � scatcoln'� AT-CONNECT :

..: AT-CONNECT S" I am connected" S" owner" S-SAY-TO ;.. \ ��������� ��������� ������������ owner

�������� :
S-SAY ( a u -- ) \ ��������� ��������� � ����� (�������� ������ ����� ������� JOIN)
S-SAY-TO ( a u user-a user-u -- ) \ ��������� ��������� ����������� ������������
S-NOTICE-TO ( a u user-a user-u -- ) \ �������
S-REPLY ( a u -- ) \ �������� � �������� �������
S-NOTICE-REPLY ( a u -- ) \ �������

message-sender ( -- a u ) \ ����������� ��������������� ���������


��� ���� ����� �������� ������ �� ������� (!help !say):

MODULE: BOT-COMMANDS-HELP
: !say S" Usage: !say <message> - bot will reply <message>" S-REPLY ;
;MODULE

