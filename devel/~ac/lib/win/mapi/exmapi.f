( ������ ��� ������� Extended MAPI.
  ����� ������� ��� ��������, ���������� � �������� ��������
  [���������/�����/������� � �.�.] � ����� MAPI-���������� -
  MS Outlook, Exchange, MAPILab Groupware, Oxchange � �.�.
  ������� ��. � mapi_test.f � list.f.

  ~ac 06.07.2007 $Id: exmapi.f,v 1.5 2007/11/09 17:44:54 spf Exp $
)

REQUIRE IID_IMAPISession ~ac/lib/win/mapi/interfaces.f
REQUIRE PT_STRING8       ~ac/lib/win/mapi/const.f
REQUIRE DumpRowSet       ~ac/lib/win/mapi/enum.f 
REQUIRE MAPIInitialize   ~ac/lib/win/mapi/funct.f

REQUIRE {                ~ac/lib/locals.f
REQUIRE STR@             ~ac/lib/str5.f \ ������������ ������ � ��������
REQUIRE DLOPEN           ~ac/lib/ns/dlopen.f 

USER uMapiSession  : MapiSession  uMapiSession @ ;
USER uMapiStores   : MapiStores   uMapiStores @ ;
USER uMapiStoresRS : MapiStoresRS uMapiStoresRS @ ;
USER uMapiStore    : MapiStore    uMapiStore @ ;
USER uMapiFolder   : MapiFolder   uMapiFolder @ ;
USER uMapiMessage  : MapiMessage  uMapiMessage @ ;

0 VALUE aMAPIAllocateBuffer \ ��� ���������� MIME->MAPI
0 VALUE aMAPIFreeBuffer

( !!!!!! ��������� ������� MAPI ���������� ������ ������� ������� !!!!!! )
( !!!!!! �� C:\Program Files\Common Files\System\Mapi\1049 !!!!!! )
( !!!!!! �������� ������� ������ ��� SaveDir/RestDir !!!!!! )
( !!!!!! �� ��� �� ������� �������������� ������������ ���� ������������ ! )
( !!!!!! ���� ��� �����, ��� "���������" ������������ ��������� � MAPI - ������! :)

WINAPI: GetCurrentDirectoryA KERNEL32.DLL
WINAPI: SetCurrentDirectoryA KERNEL32.DLL

USER uMapiDir

: MapiSaveDir
  4000 ALLOCATE THROW DUP uMapiDir !
  DUP 4000 GetCurrentDirectoryA + 0!
;
: MapiRestDir ( -- )
  uMapiDir @ SetCurrentDirectoryA DROP
;
: MapiLogon { profile-a profile-u pass-a pass-u \ madll -- ior }
  MapiSaveDir
  0 ( ��. �� 0 ��� �������������� ) MAPIInitialize MapiRestDir ?DUP IF EXIT THEN
  uMapiSession
  \ 0x2033 
  MAPI_EXTENDED MAPI_NEW_SESSION OR 
  profile-a IF MAPI_EXPLICIT_PROFILE ELSE MAPI_USE_DEFAULT THEN OR
  pass-a profile-a 0 MAPILogonEx MapiRestDir ?DUP IF EXIT THEN
  S" MAPI32.DLL" DLOPEN -> madll
  S" MAPIAllocateBuffer" madll DLSYM TO aMAPIAllocateBuffer
  S" MAPIFreeBuffer" madll DLSYM TO aMAPIFreeBuffer
  0
;
\ ��������� ������� ���� �������� THROW ��� �������

: MapiGetStores ( -- )
  uMapiStores 0 MapiSession ::GetMsgStoresTable THROW
  uMapiStoresRS  0 0 0 0 MapiStores HrQueryAllRows@24 THROW
;
: MapiGetStoreIdByName ( addr u -- ida idu )
  MapiStoresRS PR_DISPLAY_NAME 2SWAP MapiRow@ DUP 0= IF 70003 THROW THEN
  ( row ) PR_ENTRYID MapiRowProp@ 0= IF 70005 THROW THEN
;
: MapiGetStoreIdByProv ( addr u -- ida idu )
  MapiStoresRS PR_PROVIDER_DISPLAY 2SWAP MapiRow@ DUP 0= IF 70003 THROW THEN
  ( row ) PR_ENTRYID MapiRowProp@ 0= IF 70005 THROW THEN
;
: MapiGetDefaultStoreId ( -- ida idu )
  MapiStoresRS PR_DEFAULT_STORE 0 0x80040001 ( true) MapiRow@ DUP 0= IF 70006 THROW THEN
  ( row ) PR_ENTRYID MapiRowProp@ 0= IF 70005 THROW THEN
;
: MapiOpenStore ( addr u -- )
  2>R
  uMapiStore MDB_WRITE 0
  2R> MapiGetStoreIdByName
  0 MapiSession ::OpenMsgStore THROW
  MapiRestDir
;
: MapiOpenProvStore ( addr u -- )
  2>R
  uMapiStore MDB_WRITE 0
  2R> MapiGetStoreIdByProv
  0 MapiSession ::OpenMsgStore THROW
  MapiRestDir
;
: MapiOpenDefaultStore ( -- )
  uMapiStore MDB_WRITE 0
  MapiGetDefaultStoreId
  0 MapiSession ::OpenMsgStore THROW
  MapiRestDir
;
: MapiGetInbox ( -- ida idu ) { \ ida idu }
  0 ^ ida ^ idu 0 0 MapiStore ::GetReceiveFolder THROW
  ida idu
;
: MapiGetRootFolderId ( -- ida idu )
  MapiStore PR_IPM_SUBTREE_ENTRYID MapiProp@
;
\ S" "Top of Information Store\Inbox" S" \" DROP MapiStore HrMAPIOpenFolderEx HEX U.

: MapiOpenFolder { ida idu \  folder ftype -- folder ftype }
  ^ folder ^ ftype MAPI_MODIFY MAPI_BEST_ACCESS OR 
  0 ida idu MapiStore ::OpenEntry2 THROW
  folder ftype
;
: MapiGetSubfolders { folder \ table rs -- rs }
  ^ table 0 folder ::GetHierarchyTable THROW
  ^ rs 0 0 0 0 table HrQueryAllRows@24 THROW
  rs
;
: MapiGetSubfolderIdByName ( addr u folder -- ida idu )
  MapiGetSubfolders PR_DISPLAY_NAME 2SWAP MapiRow@ DUP 0= IF 70003 THROW THEN
  ( row ) PR_ENTRYID MapiRowProp@ 0= IF 70005 THROW THEN
;
: (MapiOpenFolderPath) ( -- folder )
  MapiGetRootFolderId MapiOpenFolder DROP ( folder1 ) >R
  BEGIN
    [CHAR] / PARSE DUP
  WHILE
    R> MapiGetSubfolderIdByName MapiOpenFolder DROP >R
  REPEAT 2DROP R>
;
: MapiOpenFolderPath ( addr u -- folder )
  ['] (MapiOpenFolderPath) EVALUATE-WITH
;
: MapiGetIPF { class-a class-u \ root table rs -- ida idu } \ ����. IPF.Appointment, IPF.Task
  MapiGetRootFolderId MapiOpenFolder DROP -> root
  ^ table 0 root ::GetHierarchyTable THROW
  ^ rs  0 0 0 0 table HrQueryAllRows@24 THROW
  rs PR_CONTAINER_CLASS class-a class-u MapiRow@ DUP 0= IF 70013 THROW THEN
  ( row ) PR_ENTRYID MapiRowProp@ 0= IF 70015 THROW THEN
;
: MapiOpenItem { ida idu \  item itype -- item itype }
  ^ item ^ itype 0
  0 ida idu MapiFolder ::OpenEntry3 THROW
  item itype
;
: MapiOpenInbox ( -- folder ) \ IFolder
  MapiGetInbox MapiOpenFolder DROP
;
: MapiEnumX { folder xt xte \ table rcount rs -- }

  ^ table 0 folder xte EXECUTE THROW
  ^ rcount 0 table ::GetRowCount THROW

  BEGIN
    rcount 0 >
  WHILE
    ^ rs 0 10 table ::QueryRows THROW \ ������ 10 �� ����
    rs xt MapiForEach
    rcount rs @ - -> rcount
  REPEAT
;
: MapiEnumContent ( folder xt -- )
  ['] ::GetContentsTable MapiEnumX
;
: MapiEnumSubfolders ( folder xt -- )
  ['] ::GetHierarchyTable MapiEnumX
;
: MapiEnumAtt ( message xt -- )
  ['] ::GetAttachmentTable  MapiEnumX
;
: MapiEnumRcpt ( message xt -- )
  ['] ::GetRecipientTable MapiEnumX
;

: MapiNewMessage { class-a class-u \ msg -- }
\ IPM.Activity - �������, IPM.Task - ������, IPM.Note - ��������� (��������)
\ IPM.StickyNote - �������, IPM.Appointment - ������� (���������), IPM.Contact
\ IPM.Post.Rss - ���� � ����� "RSS-������"
  ^ msg 0 0 MapiFolder ::CreateMessage THROW
  class-a class-u msg PR_MESSAGE_CLASS MapiProp!
          msg PR_CREATION_TIME MapiProp@ ( x1 x2 )
     2DUP msg PR_MESSAGE_DELIVERY_TIME MapiProp! \ ��� ���� ������������ � "��������"
          msg PR_CLIENT_SUBMIT_TIME MapiProp! \ ������������ ��� ::SubmitMessage (������ ����, �.�. ����� ����� � ��������� "����������: ���" � �� ���������� "��������� ���������")
      0 0 msg PR_MESSAGE_FLAGS MapiProp! \ ����� read � unsent-������ (=9, ������� �������� �� ���������, �.�. ��������� ����������)
  \ CLEAR_READ_FLAG msg ::SetReadFlag THROW
  msg uMapiMessage !
;
: MapiSubject! ( subj-a subj-u -- )
  MapiMessage PR_SUBJECT MapiProp!
;
: MapiSubject@ ( -- subj-a subj-u )
  MapiMessage PR_SUBJECT MapiProp@
;
: MapiSender! ( email-a email-u name-a name-u -- )
  2DUP MapiMessage PR_SENT_REPRESENTING_NAME MapiProp! \ ��� ��� ������������ � "��"
       MapiMessage PR_SENDER_NAME MapiProp!
  2DUP MapiMessage PR_SENT_REPRESENTING_EMAIL_ADDRESS MapiProp!
       MapiMessage PR_SENDER_EMAIL_ADDRESS MapiProp!
  S" SMTP" MapiMessage PR_SENDER_ADDRTYPE MapiProp!
;
: MapiSender@ ( -- email-a email-u name-a name-u )
  MapiMessage PR_SENT_REPRESENTING_EMAIL_ADDRESS MapiProp@
  MapiMessage PR_SENT_REPRESENTING_NAME MapiProp@
;
: MapiBody! ( body-a body-u -- )
  MapiMessage PR_BODY MapiProp!
;
: MapiHeaders! ( hdr-a hdr-u -- )
  MapiMessage PR_TRANSPORT_MESSAGE_HEADERS MapiProp!
;
\ ������ ����� �� ���� ������� ���������� :)
: _DISPLAY_NAME  S" MAPI Lib" DROP ;
: _EMAIL_ADDRESS S" libmapi@forth.org.ru" DROP ;
: _ADDRTYPE      S" SMTP" DROP ;

CREATE MapiAddrProps
HERE
PR_ADDRTYPE       , 0 , _ADDRTYPE , 0 ,
PR_EMAIL_ADDRESS  , 0 , _EMAIL_ADDRESS , 0 ,
PR_DISPLAY_NAME   , 0 , _DISPLAY_NAME , 0 ,
PR_RECIPIENT_TYPE , 0 , MAPI_TO , 0 ,
\ CREATE MapiAddrList
1 , 0 , 4 , MapiAddrProps ,
HERE SWAP - CONSTANT /MapiAddrProps

: MAP+ ( addr n -- addr2 ) 4 CELLS * + CELL+ CELL+ ;

: MapiAddRcptX { email-a email-u name-a name-u mode field \ al -- }
  /MapiAddrProps ALLOCATE THROW -> al
  MapiAddrProps al /MapiAddrProps MOVE
  email-a al 1 MAP+ !  name-a al 2 MAP+ !  field al 3 MAP+ !
  al  al 4 MAP+ CELL+ !
  al 3 MAP+ CELL+ CELL+ mode MapiMessage ::ModifyRecipients THROW
  al FREE THROW
;
: MapiAddRcpt ( email-a email-u name-a name-u -- )
  MODRECIP_ADD MAPI_TO MapiAddRcptX
;
: MapiAddRcptCc ( email-a email-u name-a name-u -- )
  MODRECIP_ADD MAPI_CC MapiAddRcptX
;
: MapiAddRcptBcc ( email-a email-u name-a name-u -- )
  MODRECIP_ADD MAPI_BCC MapiAddRcptX
;
: MapiAddAtt { body-a body-u name-a name-u ct-a ct-u \ att num -- num }
  ^ att ^ num 0 0 MapiMessage ::CreateAttach THROW
  0 ATTACH_BY_VALUE att PR_ATTACH_METHOD MapiProp!
  body-a body-u att PR_ATTACH_DATA_BIN MapiProp!
  name-a name-u att PR_ATTACH_FILENAME MapiProp!
  0 body-u att PR_ATTACH_SIZE MapiProp! \ MAPI ��� ������ ���� ������, ������ ��������� ���� ������ ����� ����� � ��� �����-�� ������
  ct-a ct-u att PR_ATTACH_MIME_TAG MapiProp!
  4 att ::SaveChanges THROW
  att ::Release THROW
  num
;

0 INVERT 1 RSHIFT CONSTANT MAX-INT

: MapiSaveAtt { addr u num \ att astream stream bug -- }
  ^ att 0 0 num MapiMessage ::OpenAttach THROW
  ^ astream 0 0 IID_IStream PR_ATTACH_DATA_BIN att ::OpenProperty IF att ::Release THROW EXIT THEN \ ������������ ����� � PST?
  ^ stream 0 addr STGM_CREATE STGM_READWRITE OR aMAPIFreeBuffer aMAPIAllocateBuffer OpenStreamOnFile THROW
\ !!! �� ����, ��� ��� �� ������������������� 5� �������� (������� � ������ bug), �� ��� ���� ::CopyTo �������� ���������� �����!
  bug 0 0 MAX-INT stream astream ::CopyTo THROW
  stream ::Release THROW
  astream ::Release THROW
  att ::Release THROW
;

: MapiImportMime { addr u \ conv stream -- }
\ ��������� �������� ������ �� ����� addr u � ������� (�����������) ���������.
  CLSID_IConverterSession CreateObject THROW -> conv

  ^ stream 0 addr 0 aMAPIFreeBuffer aMAPIAllocateBuffer OpenStreamOnFile THROW
  \ ��� SHCreateStreamOnFile

  \ 1 conv @ ::SetEncoding .( se=) U.

  0 0 MapiMessage stream conv ::MIMEToMAPI THROW
  stream ::Release THROW
  conv ::Release THROW
;
: MapiExportMime { addr u \ conv stream -- }
\ �������� ������� ��������� � ����.
  CLSID_IConverterSession CreateObject THROW -> conv

  ^ stream 0 addr STGM_CREATE STGM_READWRITE OR aMAPIFreeBuffer aMAPIAllocateBuffer OpenStreamOnFile THROW
  \ ��� SHCreateStreamOnFile

  \ 1 conv @ ::SetEncoding .( se=) U.

  CCSF_SMTP stream MapiMessage conv ::MAPIToMIMEStm THROW
  stream ::Release THROW
  conv ::Release THROW
;
: MapiRtfBody@ { msg \ compr uncompr rlen buff crc magic rawsize csize -- addr u }
  msg PR_RTF_COMPRESSED MapiProp@
  DROP IF
    ^ compr 0 0 ( STGM_READ | STGM_DIRECT = 0 )
    IID_IStream PR_RTF_COMPRESSED msg ::OpenProperty THROW

    \ ��� ��� ����������� ������� ��������� ������, ������ ����������������� � RTF ::Stat
    \ ������ LZFU-���������:
    ^ rlen 4 CELLS ^ csize compr ::Read THROW magic 0x75465A4C <> IF 70020 THROW THEN
    0 0 0 0 compr ::Seek THROW

    ^ uncompr 0 compr WrapCompressedRTFStream THROW

    rawsize ALLOCATE THROW -> buff
    ^ rlen rawsize buff uncompr ::Read THROW

    uncompr ::Release THROW
    compr ::Release THROW
    buff rawsize
  ELSE S" " THEN
;
: MapiSubmit 0 MapiMessage ::SubmitMessage THROW ; \ ��������� � ��������� (���������� �� �����, �� �������� �� ������)
: MapiSave 4 MapiMessage ::SaveChanges THROW ; \ ��������� ��������� ���������
