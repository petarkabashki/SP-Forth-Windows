\ ��������� ������ ������ ���������� ~ac/lib/win/arc/gzip/zlib.f

( gzip [ addr u -- addr2 u2 ] - ����� ���������� �����
  � ������� GZIP [RFC1952].
  ��� ���������� ���������� �������� �������� 
  ��������� ������ ����������� ������� zlib->gzip.
  ��� ������ ����������� ������ � ���� ���������� �������
  .gz ���� [��� �������� ����� � ���� ��������� �����,
  �.�. ��������� �� ����, � �����]
  ��� ������ � ����� ������������� ������������
  Content-Encoding: gzip, �.�. ��������������� �����
  ����������� � ���� http-������.

  gzip_write [ addr u -- ] - ��� ������������� ������ 
  WRITE-FILE, WriteSocket ��� TYPE
  - ������� ���������� ����� � ���������� � ������� GZIP [RFC1952]
  ��� ������ ������������ ����� VECT gzip_write_function,
  ������� �� ��������� ��������� TYPE.
  gzip_write ���������, ��� gzip[] �� ���� ����������
  �������� ����������� � ������ � ��������� �������������� ������.

  zlib_compress � zlib_uncompress [ addr u -- addr2 u2 ]
  ���������� ������ zlib deflate [RFC1950]

  [���������� 01.10.2007] dll ������ � CVS. ���� �� ������ �����,
  ��� �������, �� ����� ������: http://www.forth.org.ru/ext/zlib.dll [������ 1.1.4 �� 2003�]
  ��� http://www.zlib.net/ [������� 1.2.3]
)

REQUIRE SO            ~ac/lib/ns/so-xt.f

ALSO SO NEW: zlib1.dll
ALSO SO NEW: libz.so.1

\ int compress (Bytef *dest, uLongf *destLen, const Bytef *source, uLong sourceLen); 
\ Compresses the source buffer into the destination buffer. 
\ sourceLen is the byte length of the source buffer. Upon entry, 
\ destLen is the total size of the destination buffer, which must 
\ be at least 0.1% larger than sourceLen plus 12 bytes. Upon exit, 
\ destLen is the actual size of the compressed buffer.
\ This function can be used to compress a whole file at once if the 
\ input file is mmap'ed.
\ compress returns Z_OK if success, Z_MEM_ERROR if there was not 
\ enough memory, Z_BUF_ERROR if there was not enough room in the 
\ output buffer.

 0 CONSTANT Z_OK
-4 CONSTANT Z_MEM_ERROR
-5 CONSTANT Z_BUF_ERROR

: zlib_version ( -- addr u ) \ -- S" 1.2.3"
  0 zlibVersion ASCIIZ>
;
: zlib_compress ( addr u -- addr2 u2 )
  SWAP OVER 110 100 */ 12 +
  DUP ALLOCATE THROW DUP >R SWAP >R
  RP@ SWAP
  4 compress
  Z_OK = IF 2R> ELSE 2R> DROP FREE THROW S" " THEN
;
: zlib_uncompress ( addr u -- addr2 u2 )
  SWAP OVER 10000 100 */
  DUP ALLOCATE THROW DUP >R SWAP >R
  RP@ SWAP
  4 uncompress
  Z_OK = IF 2R> ELSE 2R> DROP FREE THROW S" " THEN
;
: CRC32 ( addr u -- crc32 )
  SWAP 0 3 crc32 \ crc32
;
: ADLER32 ( addr u -- crc32 )
  SWAP 1 3 adler32 \ adler32 � zlib-������� ������������ � big endian
;
CREATE gzip_header
0x1F C, 0x8B C, \ gzip_id
08 C,           \ compression=deflate
0 C,            \ flags 1=text, 2=hcrc, 4=extra, 8=fname, 16=comment
0 ,             \ unix mtime
0 C,            \ xfl
0 C,            \ OS: win=0, unix=3
HERE gzip_header - CONSTANT /gzip_header

VECT gzip_write_function ' TYPE TO gzip_write_function

( ������������ ��������� zlib-�������:
section 2.2 in rfc1950:
CMF: 0x78
bits 0 to 3: compression method 8 = deflate
bits 4 to 7: window size 32kB
FLG: 0x9C
bits 0 to 4: check bits, 0x789C = 30876, which is a multiple of 31
bit 5: no preset dictionary
bits 6 to 7: compression level 2, irrelevant for decompression 
)

: zlib_data ( addr u -- addr2 u2 ) \ zlib specification [RFC-1950], deflate specification [RFC-1951]
\ ������� zlib/deflate-������ c ���������� ������ zlib_compress
\ ��� �������������� � gzip-������
\ ���� ��� ������ http-������� � ���������� Content-Encoding: deflate (��� �������� ����� IE ����� ���� �������� 789C :)
  6 - SWAP 2+ SWAP \ �������� 2 ����� � ������
                   \ 0x78 - Compression method/flags code
                   \ 0x9C - Additional flags/check bits
                   \ � 4 ����� � ����� (Adler-32 checksum)
;
: gzip
  DUP >R
  2DUP CRC32 >R
  zlib_compress OVER >R \ ����� ���������
  zlib_data             \ ������ ����
  DUP /gzip_header + 2 CELLS + DUP >R \ ������ ������� gzip
  ALLOCATE THROW >R
  gzip_header R@ /gzip_header CMOVE
  R@ /gzip_header + SWAP CMOVE
  R> R> R> FREE THROW
  2DUP + R> OVER 8 - ! R> SWAP 4 - !
;
: gzip_write ( addr u -- )
  DUP >R
  2DUP CRC32 >R
  gzip_header /gzip_header gzip_write_function
  zlib_compress
  zlib_data
  gzip_write_function
  RP@ 4 gzip_write_function \ crc
  RDROP RP@ 4 gzip_write_function \ size
  RDROP
;
PREVIOUS PREVIOUS

\EOF

REQUIRE FILE ~ac/lib/str5.f
: TEST
  H-STDOUT >R
  S" zlib.h.gz" R/W CREATE-FILE THROW TO H-STDOUT
  S" zlib.h" FILE gzip TYPE \ gzip_write
  H-STDOUT CLOSE-FILE THROW
  R> TO H-STDOUT
; TEST
