\ 11.Dec.2003

\ Subject: [Spf-dev] hash, ��������� ����
\ From: Dmitry Yakimov <ftech@tula.net>
\ Message-ID: <726773708.20031210200651@tula.net>
\ To: spf-dev@lists.sourceforge.net
\ Date: Wed, 10 Dec 2003 20:06:51 +0300

\ http://www.isthe.com/chongo/tech/comp/fnv/#FNV-source
\ ��������� ����� ���� ������ lookup ������� ������� �����
\ ��� ������� �������� ������� 2^N ����� ������ xor-folding, �� ����
\ ������� ���� xor'��� � ��������.

: HASH ( addr u u1 -- u2 )
   2166136261 2SWAP
   OVER + SWAP 
   DO
      16777619 * I C@ XOR
   LOOP
   SWAP ?DUP IF UMOD THEN   
;
