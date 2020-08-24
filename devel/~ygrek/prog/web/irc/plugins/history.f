\ $Id: history.f,v 1.5 2008/12/13 21:40:52 ygreks Exp $
\ История сообщений

MODULE: bot_plugin_history

list::nil VALUE log-history

: n-get-history-> ( n --> logentry \ <-- )
   log-history list::length TUCK MIN - log-history list::nth PRO list::each-> CONT ;

{{ list
: log>string ( logentry -- a u ) cdar STR@ ;
: log>stamp ( logentry -- stamp ) car ;
}}

: secs-get-history-> ( n --> logentry \ <-- )
   TIME&DATE DateTime>Num SWAP - ( stamp )
   PRO log-history START{ list::each-> ( stamp logentry ) 2DUP log>stamp < IF CONT ELSE DROP THEN }EMERGE DROP ;

: Time>PAD { s m h -- a u } <# s #N## [CHAR] : HOLD m #N## [CHAR] : HOLD h #N## 0 0 #> ;

0 VALUE counter
20 CONSTANT counter_max

EXPORT

MODULE: VOC-IRC-COMMAND
: PRIVMSG
   S" PRIVMSG of history" log::trace
   TIME&DATE DateTime>Num { stamp -- }
   S" try previous PRIVMSG" log::trace
   PRIVMSG
   %[
     stamp %
     current-msg-text irc-action? >R
     current-msg-sender stamp Num>Time Time>PAD
     R> IF " ({s}) {s} {s}" ELSE " ({s}) [{s}] {s}" THEN %
   ]% log-history list::append TO log-history
   S" PRIVMSG of history done" log::trace
  ;
;MODULE

MODULE: BOT-COMMANDS-HELP
: !last S" Usage: !last <n>|<n>min|<n>sec - bot will send last n messages from channel back to you (as NOTICEs, max 20)" S-REPLY ;
;MODULE

MODULE: BOT-COMMANDS

: !last
    0 TO counter
    0 PARSE FINE-HEAD FINE-TAIL
    RE" (\d+)\s*(min|sec)?" re_match? 0= IF BOT-COMMANDS-HELP::!last EXIT THEN
    \1 NUMBER 0= IF BOT-COMMANDS-HELP::!last EXIT THEN
    ( num )
    \2 NIP IF
     \2 S" sec" COMPARE 0= IF 1
     ELSE
     \2 S" min" COMPARE 0= IF 60
     ELSE
     DROP
     S" history regexp failed" log::warn
     S" Strange error. Please file a bugreport" S-REPLY EXIT
     THEN THEN
     * START{ secs-get-history-> counter counter_max < IF log>string current-msg-sender S-NOTICE-TO counter 1+ TO counter ELSE DROP THEN }EMERGE
    ELSE
     START{ n-get-history-> counter counter_max < IF log>string current-msg-sender S-NOTICE-TO counter 1+ TO counter ELSE DROP THEN }EMERGE
    THEN
  ;

;MODULE

;MODULE

$Revision: 1.5 $ " -- History plugin {s} loaded" STYPE CR
