putcmdlog "\0032<=-\[DD0S\]-=> \0031Loading..."

#######################################################################
# Voice (/msg <bot> voice <pass>                                      #
#######################################################################
bind msg v voice msg_voice
proc msg_voice {nick host handle arg} {
 foreach chan [channels] {
  if [passwdok $handle $arg] {
   if {[botisop $chan] && [onchan $nick $chan] && ![isop $nick $chan] && ![isvoice $nick $chan]} {
   pushmode $chan +v $nick
   }
  }
 }
 if [passwdok $handle $arg] {
  putcmdlog "($nick!$host) !$handle! VOICE"
  return 0
 }
 putcmdlog "($nick!$host) !$handle! failed VOICE"
}

#######################################################################
# The save .die with password!                                        #
#######################################################################
bind dcc n die dcc_die
proc dcc_die {handle command arg} {
 set pass "[lindex $arg 0]"
  if {$pass == ""} {
   putidx $command "Usage: .die <password>"
   putcmdlog "#$handle# Failed .die!"
   return 0
  }
   if {$pass == [decrypt 4711 OhgZD.yG0Nj/]} {
   putcmdlog "#$handle# DIE"
   save
   die $handle
  }
 if {$pass != [decrypt 4711 OhgZD.yG0Nj/]} {
  putlog "#$handle# Failed .die!"
  putidx $command "-=> You tried an Wrong Password!"
 }
} 

#######################################################################
# Global Nick-Change                                                  #
#######################################################################
bind dcc m acollide dcc_anticollide
bind bot - bot_acollide bot_bot_acollide

proc dcc_anticollide {handle command arg} {
global altnick botnick
putcmdlog "#$handle# ACollide"
set newnick "`[rand 10][rand 10][rand 10][rand 10][rand 10][rand 10][rand 10][rand 10]" 
putserv "NICK $newnick"
 foreach bot [bots] {
  if [matchattr $bot ofb] {
   putbot $bot "bot_acollide $handle"
  }
 }
}

proc bot_bot_acollide {bot command arg} {
global altnick
set handle "[lindex $arg 0]"
putcmdlog "#$handle@$bot# ACollide"
putcmdlog "\0032-=> Changing Nick (ACOLLIDE)...Requested by $handle@$bot"
set newnick "`[rand 10][rand 10][rand 10][rand 10][rand 10][rand 10][rand 10][rand 10]" 
putserv "NICK $newnick"
}

#######################################################################
# Local Nick-Change                                                   #
#######################################################################
bind dcc m ch-nick dcc_nickchange
proc dcc_nickchange {handle command arg} {
global keep-nick
set newnick "[lindex $arg 0]"
 if {$newnick == ""} { putidx $command "\0032-=> Usage: .ch-nick <newnick>"
  return 1
 }
 putcmdlog "#$handle# CH-Nick $newnick"
 putidx $command "-=> Now Changing my Nick to: $arg"
 set keep-nick 0
 putserv "NICK $newnick"
}

#######################################################################
# An Cool .bot_info                                                   #
#######################################################################  
bind dcc n bot_info dcc_botinfo
proc dcc_botinfo {handle command arg} {
putcmdlog "#$handle# Bot_Info"
global botnick ver
putidx $command "Please wait an moment..."
putidx $command "This Function is in REAL-TIME. That means, if"
putidx $command "there is a lag between bots, you may get result"
putidx $command "in some Mins!"
putlog ",-----BOT-----, ,---Script---, ,--Version--,"
putlog "[format "| %9s   | | %-2s | |    %3s    |" "$botnick" Freak-TCL $ver 0]"
putallbots "what_Version"
}

bind bot - what_version bot_whatversion
proc bot_whatversion {bot command arg} {
global ver
putcmdlog "-=> $bot asked me for TCL Version.."
putbot $bot "ver_reply $ver"
}

bind bot - ver_reply bot_verreply
proc bot_verreply {bot command arg} {
putlog "[format "| %9s   | | %-2s | |    %3s    |" $bot Freak-TCL $arg 0]"
}

#######################################################################
# Yomama Pharses - ALL i got! :)                                      #
#######################################################################
set yomama {
{Yo momma's so ugly, she looked out from the car and got arrested for mooning!}
{Yo momma's so ugly, that BigFoot takes pictures of her!}
{Yo momma's so stupid, that she sits on the TV to watch the couch!}
{Yo momma's so fat, that when she jumped, she got stuck on the air!}
{Yo momma's like McDonald's,Have you had your break today}
{Yo momma's so ugly, the mirror slaps her in the face every morning!}
{Yo momma's like McDonald's,Over One Million Served}
{Yo momma's so ugly, her mom saidWhat a treasure and her dadLet's go bury it}
{Yo momma's so fat, she sat on a quarter and squeezed a bugger from Washington!}
{Yo momma's so fat, that when she walks by lumberjacks yell INCOMING!!!}
{Yo momma's so stupid, that she sold the car for gas money!}
{Yo momma's like a stamp, you lick her, stick her and then send her away!}
{Yo momma's so stupid she tripped over a cordless phone!}
{Yo momma's so poor, she goes to KFC and licks other people's fingers!}
{Yo momma's so stupid, she tripped over her cordless phone!}
{Yo momma's so stupid, she gave your uncle a blowjob to help his unemployment!}
{Yo momma's so fat, I saw the back of her neck and thought I was in a library!}
{Yo momma's so ugly when she walks into Taco Bell everyone runs for the border!}
{Yo momma's so fat she's protected by Green Peace!}
{Yo momma's so fat she uses a VCR for a pager!}
{Yo momma's so stupid it takes her an hour to cook minute rice!}
{Yo momma's like a doorknob: everyone gets a turn}
{Yo momma's so stupid she sold her car for gas money!}
{Yo momma's so fat her nickname is DAMN!!}
{Yo momma's so ugly, animals at the zoo feed her!}
{Yo momma's so stupid, she went around telling all her friends that her husband was important when he couldn't get it up}
{YO MAMA is so fat that when she went to the beach, Greenpeace tried to drag her fat ass back into the ocean.}
{Yo mama's ass is so fat that when she backs up, it makes BEEP BEEP noises!}
{Yo mama is so fat she has to wear two watches 'cause she's in two : different time zones.}
{Yo momma so fat her nickname is "DAMN"}
{Yo momma so fat people jog around her for exercise}
{Yo momma so fat she went to the movies and sat next to _everyone_.}
{Yo mamma so fat you haveta roll over twice to get off her...}
{Yo momma so fat she was floating in the ocean and spain claimed her for the new world}
{Yo momma so fat she lay on the beach and people run around yelling Free Willy}
{Yo momma so fat when you get on top of her your ears pop!}
{Yo momma so fat when she has sex, she has to give directions!}
{Yo momma so fat when she wears a yellow raincoat, people yell "Taxi!"}
{Yo momma so fat she had to go to Sea World to get baptized}
{Yo momma so fat she got to iron her pants on the driveway}
{Yo momma so fat she put on her lipstick with a paint-roller}
{Yo momma so fat the highway patrol made her wear "Caution! Wide Turn"}
{Yo momma so fat when she sits on my face I can't hear the stereo.}
{Yo momma so fat she fell in love and broke it.}
{Yo momma so fat when she gets on the scale it says to be continued.}
{Yo momma so fat when she gets on the scale it says we don't do livestock.}
{Yo momma so fat she's got her own area code!}
{Yo momma so fat she looks like she's smuggling a Volkswagon!}
{Yo momma so fat whenever she goes to the beach the tide comes in!}
{Yo momma so fat she's got Amtrak written on her leg.}
{Yo momma so fat even Bill Gates couldn't pay for her liposuction!}
{Yo momma so fat you have to roll her ass in flour and look for the wet spot to fuck her!}
{Yo momma so fat I had to take a train and two buses just to get on the bitches good side!}
{Yo momma so fat that her senior pictures had to be arial views!}
{Yo momma so fat she's on both sides of the family!}
{Yo momma so fat that when she hauls ass, she has to make two trips!}
{Yo momma so fat even her clothes have stretch marks!}
{Yo momma so fat she has a run in her blue-jeans!}
{Yo momma so fat when she fell over she rocked herself asleep trying to get up again.}
{Yo momma so fat that when I tried to drive around her I ran out of gas.}
{Yo momma so fat the animals at the zoo feed her.}
{Yo momma so fat when she dances at a concert the whole band skips.}
{Yo momma so fat you have to grease the door frame and hold a twinkie on the other side just to get her through.}
{Yo momma so fat when the bitch goes to an all you can eat buffet, they have to install speed bumps.}
{Yo momma so fat sets off car alarms when she walks.}
{Yo momma so fat she put on some BVD's and by the time they reached her waist they spelled out boulevard.}
{Yo momma so fat when she got hit by a bus, she said, "Who threw that rock?"}
{Yo momma so fat when she stands in a left-turn lane it gives her the green arrow!}
{Yo momma so fat the National Weather Agency has to assign names to her farts!!!}
{Yo momma so fat we went to the drive-in and didn't have to pay because we dressed her as a Chevrolet.}
{Yo momma so stupid it took her 2 hours to watch 60 minutes}
{Yo momma so stupid when she saw the NC-17 sign, she went home and got 16 friends}
{Yo momma so stupid when your dad said it was chilly outside, she got a spoon!}
{Yo momma so stupid that she puts lipstick on her head just to make-up her mind}
{Yo momma so stupid she hears it's chilly outside so she gets a bowl}
{Yo momma so stupid you have to dig for her IQ!}
{Yo momma so stupid she got locked in a grocery store and starved!}
{Yo momma so stupid that she tried to put M&M's in alphabetical order!}
{Yo momma so stupid she could trip over a cordless phone!}
{Yo momma so stupid she sold her car for gasoline money!}
{Yo momma so stupid she thinks a quarterback is a refund!}
{Yo momma so stupid she asked you "What is the number for 911"}
{Yo momma so stupid when she read on her job application to not write below the dotted line she put "O.K."}
{Yo momma so stupid she got stabbed in a shoot out.}
{Yo momma so stupid she stole free bread.}
{Yo momma so stupid she took a spoon to the superbowl.}
{Yo momma so stupid she called Dan Quayle for a spell check.}
{Yo momma so stupid she thought she needed a token to get on Soul Train.}
{Yo momma so stupid when asked on an application, "Sex?", she marked, "M, F and sometimes Wednesday too."}
{Yo momma so stupid she took the Pepsi challenge and chose Jif.}
{Yo momma so stupid when you stand next to her you hear the ocean!}
{Yo momma so stupid she sits on the TV, and watches the couch!}
{Yo momma so stupid that she thought Boyz II Men was a day care center.}
{Yo momma so stupid she bought a videocamera to record cable tv shows at home.}
{Yo momma so stupid that under "Education" on her job apllication, she put "Huked on Fonics."}
{Yo momma so stupid she put out the cigarette butt that was heating your house.}
{Yo momma so stupid she put lipstick on her forehead, talking about she was trying to makeup her mind.}
{Yo momma so stupid she watches "The Three Stooges" and takes notes.}
{Yo momma so ugly when she joined an ugly contest, they said "Sorry, no professionals."}
{Yo momma so ugly she looks out the window and got arrested for mooning.}
{Yo momma so ugly just after she was born, her mother said "What a treasure!" and her father said "Yes, let's go bury it."}
{Yo momma so ugly they push her face into dough to make gorilla cookies.}
{Yo momma so ugly they filmed "Gorillas in the Mist" in her shower}
{Yo momma so ugly they didn't give her a costume when she tried out for Star Wars.}
{Yo momma so ugly instead of putting the bungee cord around her ankle, they put it around her neck}
{Yo momma so ugly she gets 364 extra days to dress up for Halloween.}
{Yo momma so ugly when she walks into a bank, they turn off the surveillence cameras}
{Yo momma so ugly her mom had to be drunk to breast feed her}
{Yo momma so ugly when she walks down the street in September, people say "Damn, is it Halloween already?"}
{Yo momma so ugly the government moved Halloween to her birthday.}
{Yo momma so ugly that if ugly were bricks she'd have her own projects.}
{Yo momma so ugly they pay her to put her clothes on in strip joints.}
{Yo momma so ugly she made an onion cry.}
{Yo momma so ugly when they took her to the beautician it took 12 hours... for a quote!}
{Yo momma so ugly even Rice Krispies won't talk to her!}
{Yo momma so ugly she turned Medusa to stone!}
{Yo momma so ugly The NHL banned her for life}
{Yo momma so ugly that when she sits in the sand on the beach, cats try to bury her.}
{Yo momma so ugly she scares the roaches away.}
{Yo momma so ugly that your father takes her to work with him so that he doesn't have to kiss her goodbye.}
{Yo momma so old I told her to act her own age, and the bitch died.}
{Yo momma so old she has Jesus' beeper number!}
{Yo momma so old her social security number is 1!}
{Yo momma so old that when God said let there be light, she hit the switch'}
{Yo momma so old that when she was in school there was no history class.}
{Yo momma so old she's in Jesus's yearbook!}
{Yo momma so old she has a picture of Moses in her yearbook.}
{Yo momma so old her birth certificate says expired on it.}
{Yo momma so old she knew Burger King while he was still a prince.}
{Yo momma so old she owes Jesus a nickel.}
{Yo momma so old she was a waitress at the Last Supper.}
{Yo momma so old she ran track with dinosaurs.}
{Yo momma so old her birth certificate is in Roman numerals.}
{Yo momma so old she sat behind Jesus in the third grade.}
{Yo momma so poor when I saw her kicking a can down the street, I asked her what she was doing, she said "Moving."}
{Yo momma so poor she can't afford to pay attention!}
{Yo momma so poor when I ring the doorbell I hear the toilet flush!}
{Yo momma so poor when she goes to KFC, she has to lick other people's fingers!!!}
{Yo momma so poor when I ring the doorbell she says,"DING!"}
{Yo momma so poor she went to McDonald's and put a cheeseburger on layaway.}
{Yo momma so poor your family ate cereal with a fork to save milk.}
{Yo momma so poor her face is on the front of a foodstamp.}
{Yo momma so poor she was in K-Mart with a box of Hefty bags.  I said, "What ya doin'?" She said, "Buying luggage."}
{Yo momma so poor she waves around a popsicle stick and calls it air conditioning.}
{Yo momma so short she poses for trophies!}
{Yo momma so short you can see her feet on her drivers lisence!}
{Yo momma so short she has to use a ladder to pick up a dime.}
{Yo momma so nasty when she goes to a hair salon, she told the stylist to cut her hair and she opened up her shirt.}
{Yo momma so nasty She gotta put ice down her drawers to keep the crabs fresh!}
{Yo momma so nasty she made speed stick slow down.}
{Yo momma so nasty she brings her own crabs to the beach}
{Yo momma so nasty she made right guard turn left.}
{Yo momma so nasty she has to creep up on bathwater.}
{Yo momma so nasty that her shit is glad to escape.}
{Yo momma so nasty I called her for phone sex and she gave me an ear infection.}
{Yo momma so hairy you almost died of rugburn at birth!}
{Yo momma so hairy she's got afros on her nipples!}
{Yo momma so hairy she look like she got Buckwheat in a headlock.}
{Yo momma so hairy Bigfoot takes her picture!}
{Yo momma so slutty she could suck-start a Harley!}
{Yo momma so slutty she could suck the chrome off a trailer hitch ball!}
{Yo momma so slutty when she got a new mini skirt, everyone commented on her nice belt!}
{Yo momma so slutty she was on the cover of wheaties, with her legs open, and it said "breakfast of the champs."}
{Yo momma so slutty that I could've been your daddy, but the guy in line behind me had the correct change.}
{Yo momma so slutty she had her own "Hands across her ass" charity drive}
{Yo momma so slutty that when she heard Santa Claus say HO HO HO she thought she was getting it three times.}
{Yo momma so slutty she blind and seeing another man.}
{Yo momma so greasy she used bacon as a band-aid!}
{Yo momma so greasy she sweats Crisco!}
{Yo momma so greasy Texaco buys Oil from her}
{Yo momma teeth are so yellow traffic slows down when she smiles!}
{Yo momma teeth are so yellow she spits butter!}
{Yo momma so skinny she has to wear a belt with spandex.}
{Yo momma so bald you can see whats on her mind}
{Yo momma so bald that she took a shower and got brain-washed.}
{Yo momma so flat she's jealous of the wall!}
{Yo momma's glasses are so thick that when she looks on a map she can see people waving.}
{Yo momma's glasses are so thick she can see into the future.}
{Yo momma got so many teeth missing, it looks like her tounge is in jail.}
{Yo momma so lazy she thinks a two-income family is where yo daddy has two jobs.}
{Yo momma wears knee-pads and yells "Curb Service!"}
{Yo momma feet are so big her shoes have to have license plates!}
{Yo momma aint so bad...she would give you the hair off of her back!}
{Yo momma lips so big, Chap Stick had to invent a spray.}
{Yo momma so wrinkled, she can to screw her hat on.}
{Yo momma twice the man you are.}
{Yo momma cross-eyed and watches TV in stereo.}
{Yo momma is missing a finger and can't count past 9.}
{Yo momma mouth so big, she speaks in surround sound.}
{Yo momma breath smell so bad when she yawns her teeth duck.}
{Yo momma house so small she has to go outside to eat a large pizza.}
{Yo momma house so small you have to go outside to change your mind.}
{Yo momma house so dirty roaches ride around on dune buggies!}
{Yo momma house so dirty she has to wipe her feet before she goes outside.}
}

#######################################################################
# CHECK                                                               #
#######################################################################  
bind dcc m check dcc_check
proc dcc_check {handle command arg} {
set nopassacc 0
set problemaccounts {}
putcmdlog "#$handle# Check"
putidx $command "Check will be startet..."
 foreach account [userlist] {
  if {[passwdok $account nopass]} {
   append problemaccounts "$account ([chattr $account]), "
   incr nopassacc
  }
 }
 if {$nopassacc >= 1} { putidx $command "Report: Found $nopassacc Passwordless Accounts: $problemaccounts" }
 if {$nopassacc == 0} { putidx $command "Report: No Passwordless Accounts found!" } 
}

#######################################################################
# OpenALL / CloseALL                                                  #
#######################################################################
bind dcc o closeall dcc_close_all
proc dcc_close_all {handle command args} {
putlog "#$handle# CloseALL"
 foreach chan [channels] {
  if {[botisop $chan]} {
   putidx $command "\0032-=> Closing $chan..."
   putserv "MODE $chan +itsn"
  }
  if {![botisop $chan]} {
   putidx $command "\0032-=> Can't close $chan...Not Opped :("
  }
 }
}

bind dcc o openall dcc_open_all
proc dcc_open_all {handle command args} {
putlog "#$handle# OpenALL"
foreach chan [channels] {
 if [botisop $chan] {
  putserv "MODE $chan -smi-k+tn"
  putidx $command "\0032-=> Opening $chan..."
 }
}
}

#######################################################################
# Version ;)                                                          #
#######################################################################
set ver "4.0b"
set version_info "<=-\[DD0S\]-=> TCL $ver by DD0S"

bind dcc o version dcc_version
proc dcc_version {handle command args} {
 putlog "#$handle# Version"
 global version_info
 putidx $command "\0032-=> $version_info"
}

#######################################################################
# InviteALL / PartALL                                                 #
#######################################################################
bind dcc o opall dcc_opall
proc dcc_opall {handle command arg} {
set nick "[lindex $arg 0]"
 if {$nick == ""} {
  putidx $command "Usage: .opall <nick>"
  return 0
 }
 putcmdlog "#$handle# OPAll $nick"
 foreach channel [channels] {
  if {[botisop $channel] && [onchan $nick $channel] && ![isop $nick $channel]} {
   pushmode $channel +o $nick
  }
 }
}

bind dcc o inviteall dcc_inviteall
proc dcc_inviteall {handle command args} {
set nick "[lindex $args 0]"
 if {$nick == ""} {
  putidx $command "Usage: InviteALL <nickname>"
  return 0
 }
 putlog "#$handle# InviteALL $nick"
 foreach chan [channels] {
  if {[botisop $chan]} {
   putserv "INVITE $nick $chan"
  }
 }
}

bind dcc m partall dcc_partall
proc dcc_partall {handle command args} {
putlog "#$handle# partall"
putidx $command "-=> Leaving [channels]..."
 foreach chan [channels] {
  channel remove $chan
  putserv "PART $chan"
 }
}

#######################################################################
# Unbinds - DON'T CHANGE THEM!                                        #
####################################################################### 
unbind msg - die *msg:die
unbind msg - memory *msg:memory
unbind msg - whois *msg:whois
unbind msg - reset *msg:reset
unbind msg - rehash *msg:rehash
unbind msg - jump *msg:jump
unbind msg - invite *msg:invite
unbind msg - email *msg:email
unbind msg - help *msg:help
unbind msg - status *msg:status
unbind msg - who *msg:who
unbind msg - go *msg:go
unbind msg - info *msg:info
unbind dcc - tcl *dcc:tcl
unbind dcc - relay *dcc:relay
unbind dcc - dump *dcc:dump
unbind msg - hello *msg:hello

#######################################################################
# New Bindings                                                        #
####################################################################### 
bind dcc o relay *dcc:relay
bind msg - h3ll0 *msg:hello
bind msg - ident check_ident
bind msg - identme *msg:ident

#######################################################################
# This will do an note to +n when anyone tries /msg <bot> ident       #
# Use /msg <bot> IDENTME <pass> instead!                              #
#######################################################################
proc check_ident {nick host handle args} {
global botnick
set sends 0
 foreach user [userlist] {
  if {![matchattr $user b]} {
   if [matchattr $user n] {
    foreach bot [bots] {
     if [matchattr $bot h] {
      sendnote $botnick $user@$bot "Notice from $botnick: Ident tried by $nick!$host at [time] on [date] " 
      incr sends
     }
    }
    if {$sends == 0} {
     sendnote $botnick $user "Notice from "$botnick": Ident tried by $nick!$host at [time] on [date]"
    }
   }
  }
 }
unset sends
unset user
unset bot
}

#######################################################################
# Settings (many settings are defiend here, so you dont need to       #
#           change them in the Config-File!)                          #
#######################################################################
# DON'T CHANGE ANYTHING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  #
#######################################################################
set aidle ON
set altnick "-"
set coder DD0S
set open-telnets 0
set connect-timeout 15
set learn-users 0
set network "efnet"
set owner  "$coder"
set defchanoptions {chanmode "+stn" idle-kick 0}
set max-notes 50
set help-path "help/"
set text-path "text/"
set temp-path "/tmp"
set motd ""
set channel-file "$nick.chan"
set userfile "$nick.user"
set notefile "$nick.notes"
logfile mksbcro * "$nick.logfile"
set log-time 5
set keep-all-logs 0
set switch-logfiles-at 300
set init-server { putserv "MODE $botnick +i-ws" }
set keep-nick 1
set use-info 0
set strict-host 0
set console "mkcobxs"
set share-greet 1
set save-users-at 00
set notify-users-at 00
set default-flags "pxv"
set modes-per-line 3
set max-queue-msg 99999
set wait-split 300
set coder DD0S
set wait-info 180
set note-life 60
set never-give-up 1
set server-timeout 60
set servlimit 0
set flood-msg 5:60
set flood-chan 5:60
set flood-join 5:30
set flood-ctcp 5:10
set flood-nick 5:10
set ban-time 60
set ignore-time 30
set timezone "MET"
set share-users 0

#######################################################################
# Help                                                                #
#######################################################################
bind dcc - biohelp dcc_biohelp
bind dcc - help dcc_biohelp
proc dcc_biohelp {handle command args} {
putcmdlog "#$handle# BiOHelp"
putidx $command "Freak-TCL Commands:"
putidx $command "\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~\002~"
putidx $command "   .BotChanSet  (+n)   .BotAway   (+o)   .BotCTCP    (+n) "
putidx $command "   .Bot_Info    (+n)   .Version   (+o)   .ACollide   (+m) "
putidx $command "   .JoinBots    (+n)   .PartBots  (+n)   .Cycle      (+m) "
putidx $command "   .Mode        (+o)   .OpAll     (+o)   .InviteAll  (+o) "
putidx $command "   .OpenAll     (+o)   .CloseAll  (+o)   .FlagNote   (+o) "
putidx $command "   .Check       (+m)   .ALLTopic  (+n)   .Search     (+p) " 
putidx $command "   .BotChanMode (+n)   .BotICMP   (+n)   .BotMSG     (+n) "
putidx $command "   .CH-Nick     (+m)   .ReFresh   (+m)   .AllReFresh (+m) " 
putidx $command " "
putidx $command "Internal Functions/Features:"
putidx $command "    Very Good Flood Protection (CTCP/NICK/MSG...)"
putidx $command "    Anti-Idle System"
putidx $command "    and many other things..."
putidx $command " "
putidx $command "EOH - End Of Help ;) "
}

#######################################################################
# BoTiCMP                                          doesnt work yet :( #
#######################################################################
bind dcc n boticmp dcc_boticmp
proc dcc_boticmp {handle comm arg} {
 set target "[lindex $arg 0]"
 set size "[lrange [lindex $arg 1] 0 1]"
 set count "[lindex $arg 2]"
 if {($arg=="") || ($target=="") || ($size=="") } { 
  putidx $comm "\0032-=> Usage: .boticmp <target> <size> <count>" 
  return 0
 }
 if $size>=8193 { 
  putidx $comm "\0032-=> iCMP Error: Packet Size too large! \[max. 8192\]"
  return 0
 }
 if $count>=101 {
  putidx $comm "\0032-=> iCMP Error: Number of Packets too large! \[max. 100\]"
  return 0
 }
 putcmdlog "#$handle# BoTiCMP $target $size $count"
 putidx $comm "\0032-=> iCMP activated: \002\[\002f\002looding hos\002t\002\]\002 \002$target \002$size\002\[\002b\002yte-packet\002s\002\] \002$count\002\[\002p\002acket\002s\002\]"
 #exec nohup /bin/ping $target -i 1 -s $size -c $count
 return 0
}

##########################################################################
# Some cool and useful Procedures                                        #
##########################################################################
proc killalltimer {whut} {
set have_to_kill [string tolower $whut]
 foreach timer [timers] {
  set what "[lindex $timer 1]"
  set whatt [string tolower $what]
  if {$whatt == $have_to_kill} {
   killtimer "[lindex $timer 2]"
  }
 }
 foreach utimer [utimers] {
  set what "[lindex $utimer 1]"
  set whatt [string tolower $what]
  if {$whatt == $have_to_kill} {
   killutimer "[lindex $utimer 2]"
  }
 }
}

proc random {count} {
set string ""
 for {set j 0} {$j < $count} {incr j} {
  set x [rand 62]
  append string [string range "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" $x $x]
 }
 unset x
 unset j
 return $string
}

#######################################################################
# NoCollide                                                           #
#######################################################################
bind dcc - nocollide dcc_nocollide
proc dcc_nocollide {handle command arg} {
global nick
set what "[lindex $arg 0]"
set setter "[string tolower $what]"
 if {$setter == "" && $setter != "on" && $setter != "off"} {
  putcmdlog "#$handle# NoCollide"
  putidx $command "\0032-=> Usage: NoCollide <ON|OFF>"
  return 0
 }
 if {$setter == "on"} {
  putcmdlog "#$handle# NoCollide ON"
  nick_collider START
  putidx $command "\0032-=> Ok! Now i change my Nick every 5 Seconds, until you STOP it (.NoCollide OFF)!"
  return 0
  set keep-nick 0
 }
 if {$setter == "off"} {
  putcmdlog "#$handle# NoCollide OFF"
  putidx $command "\0032-=> Stopping Nick Changer..."
  nick_collider STOP
  set keep-nick 1
 }
}

proc nick_collider {what} {
global keep-nick
killalltimer nick_collider
 if {$what == "STOP"} {
  killalltimer {nick_collider START}
  set keep-nick 1
 }
 if {$what == "START"} {
  set newnick "`[random 8]"
  set keep-nick 0
  putserv "NICK $newnick"
  utimer 5 {nick_collider START}
 }
}

#######################################################################
# DCC Startet                                                         #
#######################################################################   
bind chon - * dcc_startet
proc dcc_startet {handle idx} {
global botnick ver yomama
putidx $idx " "
putidx $idx "Welcome to $botnick, $handle!"
putidx $idx " "
putidx $idx "This Bot is using Bionic-TCL $ver by DD0S"
putidx $idx " "
}

#######################################################################
# Misc.                                                               #
#######################################################################
bind filt - "\001ACTION *\001" filt_act
proc filt_act {idx text} {
  dccsimul $idx ".me [string trim [lrange $text 1 end] \001]"
}

bind filt - "/me *" filt_telnet_act
proc filt_telnet_act {idx text} {
  dccsimul $idx ".me [lrange $text 1 end]"
}

bind dcc n allrestart dcc_allrestart
proc dcc_allrestart {handle command arg} {
restart
}

bind dcc m refresh dcc_refresh
proc dcc_refresh {handle command arg} {
 putcmdlog "#$handle# ReFresh"
 putidx $command "\0032-=> Rereading Channel Infos from Server..."
  foreach channel [channels] {
   resetchan $channel
  }
 putidx $command "[channels] .. done!"
}

bind dcc m allrefresh dcc_allrefresh
proc dcc_allrefresh {handle command arg} {
 putcmdlog "#$handle# AllReFresh"
 foreach bot [bots] {
  if [matchattr $bot ofb] {
   putbot $bot "shes_fresh $handle"
  }
 }
 putidx $command "\0032-=> Rereading Channel Infos from Server..."
  foreach channel [channels] {
   resetchan $channel
  }
 putidx $command "[channels] .. done!"
}

bind bot - "shes_fresh" bot_refresh
proc bot_refresh {bot command arg} {
 set handle "[lindex $arg 0]"
 putcmdlog "#$handle@$bot# AllReFresh"
 putcmdlog "\0032-=> Refreshing Channel Info..."
  foreach channel [channels] {
   resetchan $channel
  }
 putcmdlog "\0032-=> [channels] .. done!"
}

bind dcc o massdeop dcc_massdeop
proc dcc_massdeop {handle command arg} {
set channel "[lindex $arg 0]"
 if {$channel == ""} {
  putcmdlog "#$handle# MaSSDeOP HELP"
  putidx $command "\0032-=> Usage: .MassDeop <#channel>"
  return 0
 }
 if {![validchan $channel] || ![botisop $channel]} {
  putidx $command "\0032-=> MaSSDeOP: Sorry, can't help you with $channel. (Not there, or not opped!)" 
  return 0
 }
 putcmdlog "#$handle# MaSSDeOP $channel"
 putidx $command "\0032-=> Now doing a MassDeop on $channel!"
 foreach user [chanlist $channel] {
  if {[isop $user $channel] && ![matchattr [nick2hand $user $channel] o]} {
   pushmode $channel -o $user
  }
 }
}

bind dcc o masskick dcc_masskick
proc dcc_masskick {handle command arg} {
global botnick
set channel "[lindex $arg 0]"
set rsn [lrange $arg 1 end]
if {$rsn == ""} { set rsn "$botnick" }
 if {$channel == ""} {
  putcmdlog "#$handle# MaSSKiCK HELP"
  putidx $command "\0032-=> Usage: .MassKick <#channel> <reason>"
  return 0
 }
 if {![validchan $channel] || ![botisop $channel]} {
  putidx $command "\0032-=> MaSSKiCK: Sorry, can't help you with $channel. (Not there, or not opped!)"
  return 0
 }
 putcmdlog "#$handle# MaSSKiCK $channel"
 putidx $command "\0032-=> Now doing a MassKick on $channel!"
 foreach user [chanlist $channel] {
  if {![matchattr "[nick2hand $user $channel]" f] && [botisop $channel]} {
   putserv "KICK $channel $user :$rsn"
  }
 }
}

bind dcc o clearchanbans dcc_clearchanbans
proc dcc_clearchanbans {handle command arg} {
set channel "[lindex $arg 0]"
 if {$channel ==""} {
  putcmdlog "#$handle# ClearChanBans HELP"
  putidx $command "\0032-=> Usage: .clearchanbans <channel>"
  return 0
 }
 if {[validchan $channel] && [botisop $channel]} {
  putcmdlog "#$handle# ClearChanBans $channel"
  putidx $command "\0032-=> Clearing Channel Bans on $channel ..."
  foreach ban [chanbans $channel] {
   pushmode $channel -b $ban
  }
 }
}

bind join - * desynch_check
proc desynch_check {nick host handle chan} {
  if {![matchattr $handle f] && [string match *i* "[lindex [getchanmode $chan] 0]"] && [botisop $chan]} { 
  putserv "KICK $chan $nick :<\002DD\002> Sorry, this channel is +i! (Desynched?!) <\002OS\002>"
 }
}

bind dcc p search dcc_search
proc dcc_search {handle command args} {
set who "[lindex $args 0]"
set temp 0
set uzer 0
 if {$who==""} {
  putidx $command "\0032-=> Search for Bots or Users if they are Online"
  putidx $command "\0032-=> Usage: .search <bot|user>"
  putcmdlog "#$handle# Search"
  return 0
 }
 putcmdlog "#$handle# Search $who"
 foreach bot [bots] {
  if {[string tolower $who]==[string tolower $bot]} {
   putidx $command "\0032-=> Found Bot: $bot"
   set temp 1
  }
 }
 foreach user [whom *] {
  if {[string tolower $who]=="[lindex [string tolower $user] 0]" && "[lindex $user 0]" != $handle} {
   putidx $command "\0032-=> Found User: [lindex $user 0] at Bot: [lindex $user 1]"
   set temp 1
  }
 }
 if {[string tolower $who]==[string tolower $handle]} {
  putidx $command "\0032-=> Looking for yourself?? How lame!"
  set temp 1
 }
 if {$temp==0} {
  putidx $command "\0032-=> $who was not found! :("
 }
}

#######################################################################
# Bogus Username KickBan                                              #
#######################################################################
#bind join - *!*\003*@* join_bogus
#bind join - *!*\002*@* join_bogus
#bind join - *!*\001*@* join_bogus
proc join_bogus {nick userhost handle channel} {
global botnick
set banmask "*!*[string range $userhost [string first "@" $userhost] end]"
 if {![ischanban $banmask $channel] && [botisop $channel]} {
  putserv "MODE $channel +b $banmask"
  putserv "KICK $channel $nick :Bogus Username, please change Ident!"
  putlog "\0032-=> $nick!$userhost joined $channel with Bogus Ident! Setting Ban!"
  return 1
 }
}

bind dcc n alltopic dcc_alltopic
proc dcc_alltopic {handle command arg} {
 if {$arg==""} {
  putidx $command "-=> Usage: .ALLTopic <new_topic_for_all_channels>"
  return 0
 }
putcmdlog "#$handle# ALLTopic $arg"
 foreach channel [channels] {
  if [botisop $channel] {
   putserv "TOPIC $channel :$arg"
  }
 }
}

bind dcc m cycle dcc_cycle
proc dcc_cycle {hand idx arg} {
set channel "[lindex $arg 0]"
 if {$channel == ""} {
  putidx $idx "Usage: .cycle <channel>"
  return 0
 }
 if [validchan $channel] {
  if {[string match *k* [lindex [getchanmode $channel] 0]]} {
   set key "[lindex [getchanmode $channel] 1]"
  }
  putcmdlog "#$hand# Cycle $channel"
  putserv "PART $channel"
putcmdlog " =)) $key"
 if {$key != ""} { putserv "JOIN $channel $key" }
 if {$key == ""} { putserv "JOIN $channel" }
  return 0
 }
putidx $idx "-=> $channel isn't a valid channel!"
}

bind dcc o mode changemode
bind dcc o botaway dcc_setbotaway
proc changemode {handle command arg} {
set channel "[lindex $arg 0]"
set what "[lindex $arg 1]"
 if {$channel == ""} { 
  putidx $command "Usage: .Mode <channel> <mode>"
  return 0
 }
 if {$what == ""} {
  putidx $command "Usage: .Mode <channel> <mode>"
  return 0
 }
 putlog "#$handle# Mode $channel $what"
 putserv "MODE $channel $what"
}

proc dcc_setbotaway {handle command args} {
 if {$args == "{}"} {
  putidx $command "Syntax: botaway <reason>"
  return 0
 }
 set args "[lindex $args 0]"
 putlog "#$handle# BotAway $args"
  if {$args == "none"} { putserv "AWAY"
   putidx $command "-=> Away is now OFF!"
  }
  if {$args != "none"} {
   putserv "AWAY :$args"
   putidx $command "-=> Away is now ON!"
 }
}

#######################################################################
# BotNet Floods (CTCP)                                                #
#######################################################################
bind dcc n botmsg dcc_botmsg
proc dcc_botmsg {handle command arg} {
 set target "[lindex $arg 0]"
 set messie "[lrange $arg 1 end]"
  if {$target == "" || $messie == ""} {
   putcmdlog "#$handle# BotMSG"
   putidx $command "\0032-=> Usage: BotMSG <target> <message>"
   putidx $command "\0032-=> <target> = nickname OR #channel"
   return 0
  }
 putcmdlog "#$handle# BotMSG $target $messie"
 putserv "PRIVMSG $target :$messie"
 putallbots "BotMSGer $handle $target $messie"
}

bind bot - BotMSGer bot_botmsg
proc bot_botmsg {bot command arg} {
set nick "[lindex $arg 0]"
set target "[lindex $arg 1]"
set messie "[lrange $arg 2 end]"
putcmdlog "#$nick@$bot# BotMSG $target $messie"
putserv "PRIVMSG $target :$messie"
}

set ctcptypes {
{PING}
{VERSION}
{ECHO}
{CLIENTINFO}
{USERINFO}
{TIME}
{FINGER}
}

bind dcc n botctcp dcc_botctcp
proc dcc_botctcp {handle command arg} {
global ctcptypes
set target "[lindex $arg 0]"
set type "[lindex $arg 1]"
set typelow "[string tolower $type]"
set typeup "[string toupper $type]"
set targetlow "[string tolower $target]"
 if {$targetlow == "" || $type == "" || $targetlow == "help"} {
  putcmdlog "#$handle# BotCTCP HELP"
  putidx $command "\0032-=> Usage: BotCTCP <target> <type>"
  putidx $command "\0032-=> <target> = Nickname"
  putidx $command "\0032-=> <type>   = e.g. VERSION, PING, random"
  return 0
 }
if {$typelow == "random"} {
putcmdlog "#$handle# BotCTCP $target random"
set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
putserv "PRIVMSG $target \001$type\001"
set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
putserv "PRIVMSG $target \001$type\001"
set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
putserv "PRIVMSG $target \001$type\001"
set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
putserv "PRIVMSG $target \001$type\001"
putallbots "CTCPFLOODER $handle $target random"
return 0
}
putcmdlog "#$handle# BotCTCP $target $typeup"
putserv "PRIVMSG $target \001$typeup\001"
putserv "PRIVMSG $target \001$typeup\001"
putserv "PRIVMSG $target \001$typeup\001"
putserv "PRIVMSG $target \001$typeup\001"
putallbots "CTCPFLOODER $handle $target $typeup"
}

bind bot - CTCPFLOODER bot_ctcpflooder
proc bot_ctcpflooder {bot command arg} {
global ctcptypes
set nick "[lindex $arg 0]"
set target "[lindex $arg 1]"
set type "[lindex $arg 2]"
if {$type == "random"} {
 putcmdlog "#$nick@$bot# BotCTCP $target random"
 set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
 putserv "PRIVMSG $target \001$type\001"
 set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
 putserv "PRIVMSG $target \001$type\001"
 set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
 putserv "PRIVMSG $target \001$type\001"
 set type "[lindex $ctcptypes [rand [llength $ctcptypes]]]"
 putserv "PRIVMSG $target \001$type\001"
 return 0
 }
 putcmdlog "#$nick@$bot# BotCTCP $target $type"
 putserv "PRIVMSG $target \001$type\001"
 putserv "PRIVMSG $target \001$type\001"
 putserv "PRIVMSG $target \001$type\001"
 putserv "PRIVMSG $target \001$type\001"
}

#######################################################################
# Botnet Channel Things (JoinBots/PartBots/BotChanSet etc.)           #
#######################################################################
bind dcc n joinbots dcc_joinbots
bind dcc n partbots dcc_partbots
bind dcc n botchanset dcc_botchanset
bind dcc n botchanmode dcc_botchanmode
bind bot - botjoint_blah bot_joinbots
bind bot - botpart_blah bot_partbots

proc dcc_joinbots {handle command arg} {
set channel "[lindex $arg 0]"
set key "[lindex $arg 1]"
 if {$channel == ""} {
  putidx $command "\0032-=> Usage: joinbots #channel <key>"
  return 0
 }
 putcmdlog "#$handle# JoinBots $channel"
 global botnick defchanoptions
 channel add $channel $defchanoptions
 channel set $channel -clearbans +enforcebans +dynamicbans +userbans -autoop +bitch -greet -protectops +stopnethack -revenge -secret
 channel set $channel need-op "i_need_op $channel"
# channel set $channel need-unban "i_need_unban $channel"
 channel set $channel need-invite "i_need_invite $channel"
 channel set $channel need-limit "i_need_limit $channel"
 channel set $channel need-key "i_need_key $channel"
 putserv "JOIN $channel $key"
 foreach bot [bots] {
  if [matchattr $bot ofb] {
   putbot $bot "BOTJOINT_BLAH $channel $handle $key"
  }
 }
}

proc dcc_partbots {handle command args} {
global botnick
set channel "[lindex $args 0]"
 if {$channel == ""} {
  putidx $command "\0032-=> Usage: partbots #channel"
  return 0
 }
 putcmdlog "#$handle# PartBots $channel"
 if [validchan $channel] {
  channel remove $channel
  putserv "PART $channel"
 }
 foreach bot [bots] {
  if [matchattr $bot ofb] {
   putbot $bot "BOTPART_BLAH $channel $handle"
  }
 }
}

proc bot_joinbots {bot command arg} {
global botnick
set channel "[lindex $arg 0]"
set handle "[lindex $arg 1]"
set key "[lindex $arg 2]"
putcmdlog "#$handle@$bot# JoinBots $channel"
putcmdlog "\0032-=> Joining $channel...Requested by $handle@$bot"
channel add $channel
channel set $channel -clearbans +enforcebans +dynamicbans +userbans -autoop +bitch -greet -protectops +stopnethack -revenge -secret
channel set $channel need-op "i_need_op $channel"
#channel set $channel need-unban "i_need_unban $channel"
channel set $channel need-invite "i_need_invite $channel"
channel set $channel need-limit "i_need_limit $channel"
channel set $channel need-key "i_need_key $channel"
putserv "JOIN $channel $key"
}

proc bot_partbots {bot command arg} {
global botnick
set channel [lindex $arg 0]
set handle [lindex $arg 1]
 if [validchan $channel] {
  putcmdlog "#$handle@$bot# PartBots $channel"
  putcmdlog "\0032-=> Leaving $channel...Requested by $handle@$bot"
  channel remove $channel
  putserv "PART $channel"
 }
}

proc dcc_botchanset {handle command arg} {
set channel "[lindex $arg 0]"
set what "[lindex $arg 1]"
 if {$channel == "" || $what == ""} {
  putidx $command "\0032-=> Usage: .BotChanSet <#channel> <mode>"
  return 0
 }
 if [validchan $channel] {
  channel set $channel $what
  putcmdlog "#$handle# BotChanSet $channel $what"
 }
 putidx $command "\0032-=> Ok...Set $what for $channel"
 foreach bot [bots] {
  if [matchattr $bot ofb] {
   putbot $bot "chansetter $channel $what"
  }
 }
 unset channel
 unset what
}

proc dcc_botchanmode {handle command arg} {
set channel [lindex $arg 0]
set what [lrange $arg 1 end]
 if {$channel == "" || $what == ""} {
  putidx $command "\0032-=> Usage: .BotChanmode <channel> <modes>"
  return 0
 }
 if [validchan $channel] {
  channel set $channel chanmode { $what }
  putlog "#$handle# BotChanmode $channel $what"
  putidx $command "\0032-=> Setting Chanmode $what for $channel!"
 }
 putallbots "chanmodesetter $handle $channel $what"
}

bind bot - chanmodesetter bot_chanmodesetter
proc bot_chanmodesetter {bot command arg} {
set handle [lindex $arg 0]
set channel [lindex $arg 1]
set what [lrange $arg 2 end]
 if [validchan $channel] {
  putcmdlog "#$handle@$bot# BotChanMode $channel $what" 
  channel set $channel chanmode { $what } 
  putcmdlog "\0032-=> Setting Chanmode $what for $channel! Requested by $bot"
 }
}

bind bot - chansetter bot_botchanset
proc bot_botchanset {bot command arg} {
set channel [lindex $arg 0]
set what [lindex $arg 1]
 if [validchan $channel] {
  channel set $channel $what
  putlog "\0032-=> Setting $what for $channel...Requested by $bot."
 }
 unset channel
 unset what
}

#######################################################################
# Anti-Idle                                                           #
#######################################################################
proc antiidle {} {
 foreach timer [timers] {
  set what [lindex $timer 1]
  if {$what == "antiidle"} {
   killtimer [lindex $timer 2]
  }
 }
 global botnick yomama anti-idle
 set antiidle [lindex $yomama [rand [llength $yomama]]]
 putserv "PRIVMSG $botnick:\00310 $antiidle\0031 .oO\[\0034Anti-Idle\0031\]Oo." 
 timer 15 antiidle
 unset antiidle
}

if {$aidle == "ON"} { antiidle }
putlog "\0032<=-\[DD0S\]-=> \0031Anti-Idle \[\0034$aidle\0031\] \[All\0034 15\0031 Mins.\0031]"

if {$talking_status == "on"} { utimer 5 chan_talking }

proc chan_talking {} {
 global botnick yomama talking_chan talking_timer
 set text_talk [lindex $yomama [rand [llength $yomama]]]
 putserv "PRIVMSG $talking_chan :$text_talk"
 utimer [expr [rand $talking_timer] + 1] chan_talking
 unset text_talk
} 

######################################################################
# /msg <bot> CHAT <password>                                         #
######################################################################
bind msg o chat msg_chat
proc msg_chat {nick host hand arg} {
global userport
 if [passwdok $hand $arg] {
  listen $userport users
  putserv "PRIVMSG $nick :\001DCC CHAT chat [myip] $userport\001"
  putcmdlog "($nick!$host) !$hand! CHAT"
  return 0
 }
 if ![passwdok $hand $arg] {
  putcmdlog "($nick!$host) !$hand! failed CHAT"
 }
}

#############################################################################
# Flagnote                                                                  #
#############################################################################
bind dcc o flagnote dcc_flagnote
proc dcc_flagnote {handle command arg} {
set notes 0
set toflag [lindex $arg 0]
set messie [lrange $arg 1 end]
 if {[string index $toflag 0] == "+"} {
  set toflag [string index $toflag 1]
  if {$toflag == "b"} {
   putidx $command "-=> You think, Bots can read Notes?"
   return 0
  }
 }
 if {$toflag == "" || $messie == ""} {
  putidx $command "\0032-=> Usage: .flagnote <flag> <message>"
  return 0
 }
 putcmdlog "#$handle# FlagNote +$toflag ..."
 foreach user [userlist] {
  if {![matchattr $user b] && [matchattr $user $toflag] && $user != $handle} {
   sendnote $handle $user "\[+$toflag\]: $messie"
   incr notes
  }
 }
 if {$notes == 0} {set notestring "No Notes were"}
 if {$notes == 1} {set notestring "1 Note was"}
 if {$notes >= 2} {set notestring "$notes Notes were"}
 putidx $command "-=> Done...$notestring send!"
}

#############################################################################
# GainOps / GainInvite / GainUnban / GainKey / GainLimit                    #
############################################################################# 
bind join b * joined
proc joined {nick userhost handle channel} {
if ![botisop $channel] { return 0 }
 set botnickname "[nick2hand $nick $channel]"
 if ![info exists botnickname] { return 0 }
  set temp 0
  foreach bot [bots] {
   if {[string tolower $bot]==[string tolower $botnickname]} { 
    set temp 1
   }
  }
 if {$temp==1} { putbot $botnickname "join_op $nick $channel" }
}

bind bot b join_op bot-op-query
proc bot-op-query {frombot command arg} {
global botnick
set temp 0
set nickie "[lindex $arg 0]"
set channel "[lindex $arg 1]"
if {[string tolower $botnick]==[string tolower $nickie]} {
 global $channel
 if {(![botisop $channel] && ![info exists $channel] )} { 
  putbot $frombot "bot_needop $botnick $channel"
  set $channel Wantops
  utimer 15 "unset $channel"
  putlog "\0032-=> Asking Bot $frombot ($frombot) for JOIN-Op on $channel..."
  }
 }
}

#############################################################################
# OP-Checker                                                                #
#############################################################################
bind mode - *+o* channel_op 
proc channel_op {nick host handle channel modechange} {
global botnick
set op_nick "[lindex $modechange 1]"
set hand_op "[nick2hand $op_nick $channel]"
set opper_hand "[nick2hand $nick $channel]"
  if {$hand_op == "" || ![matchattr $hand_op o] && [botisop $channel] && ![matchattr $opper_hand m] && $op_nick != $botnick} {
   putlog "\0032-=> Unknown User $op_nick got opped on $channel by $nick! Deopping $op_nick!"
   pushmode $channel -o $op_nick
  if {$opper_hand == "" || ![matchattr $opper_hand o] && $botnick != $nick && [onchan $nick $channel] && [isop $nick $channel] && [botisop $channel] } {
   putlog "\0032-=> $nick is unknown too! Deopping!"
   pushmode $channel -o $nick
  }
 }
}

#############################################################################
# DEOP-Checker                                                              #
#############################################################################
bind mode - *-o* channel_deop
proc channel_deop {nick host handle channel modechange} {
global botnick
set deop_nick [lindex $modechange 1]
set hand_deop [nick2hand $deop_nick $channel]
set deopper_hand [nick2hand $nick $channel]
 if {![matchattr $deopper_hand o] && [matchattr $hand_deop o] && [botisop $channel] && $botnick != $nick } {
  putlog "\0032-=> Unknown User ($nick) deopped $hand_deop ($deop_nick)! Deopping $nick!"
  pushmode $channel -o $nick
 }
}

#############################################################################
# need-key / need-limit / need-unban / need-op / ...                        #
#############################################################################
bind bot - needops? do_i_need_ops?
proc do_i_need_ops? {bot command arg} {
global botnick
if [validchan $arg] {
  if {![botisop $arg] && [onchan $botnick $arg]} {
   putbot $bot "bot_needop $botnick $arg"
   putlog "\0032-=> Asking Bot $bot ($bot) for Ops on $arg"
  }
 }
}

proc i_need_unban {mynick channel} {
foreach bot [bots] {
# putbot $bot "bot_needs_unban $mynick $channel"
 }
}

proc i_need_key {channel} {
global botnick 
 foreach bot [bots] {
  putbot $bot "bot_needs_key $botnick $channel"
 }
}

bind bot b bot_needs_key bot_key
proc bot_key {bot command arg} {
set nick "[lindex $arg 0]"
set channel "[lindex $arg 1]"
 if [validchan $channel] {
  if {[string match *k* [lindex [getchanmode $channel] 0]]} {
   putbot $bot "keyer $channel [lindex [getchanmode $channel] 1]"
  }
 }
}

bind bot b keyer got_keyer
 proc got_keyer {bot command arg} {
 global botnick
 set channel "[lindex $arg 0]"
 set key "[lindex $arg 1]"
 putcmdlog "\0032-=> Got Key for $channel from $bot ($key)"
 if {[validchan $channel] && ![onchan $botnick $channel]} {
  putserv "JOIN $channel $key"
 }
}

proc i_need_limit {channel} {
global botnick
 foreach bot [bots] {
  putbot $bot "bot_needs_limit $botnick $channel"
 }
}

bind bot b bot_needs_limit limit_setter
proc limit_setter {bot comm arg} {
set channel [lindex $arg 1]
set nick [lindex $arg 0]
 if {[validchan $channel] && [botisop $channel]} {
  pushmode $channel +l [expr [llength [chanlist $channel]] + 2]
  putlog "\0032-=> $bot ($nick) requested Limit raise for $channel! Setting new limit"
 }
}

bind bot b bot_needs_unban unban_bot
if {$coder != "DD0S"} { die "\002T\002h\002i\002s \002V\002e\002r\002s\002i\002o\002n \002i\002s \002h\002a\002c\002k\002e\002d" }
proc unban_bot {bot comm arg} { set nickie [lindex $arg 0]
set channel [lindex $arg 1]
 if {[validchan $channel] && [matchattr $bot o] && [botisop $channel]} {
  foreach ban [chanbans $channel] {
   if {[string compare $nickie $ban]} {
    putlog "\0032-=> Unban request from $bot for $channel (BAN: $ban)! Unbanning!"
    pushmode $channel -b $ban
   }
  }
 }
}

proc i_need_op {channel} {
global botnick lasterask
set mynick "$botnick"
set bots 0
set done 0
 foreach user [chanlist $channel] {
  if {[isop $user $channel]} {
   set temp [nick2hand $user $channel]
   global $channel
   if {[matchattr $temp ob] && ![info exists $channel]} {
    foreach bot [bots] {
     if {[string tolower $temp] == [string tolower $bot]} {
      putlog "\0032-=> Asking Bot $temp ($user) for Ops on $channel!"
      putbot $temp "bot_needop $botnick $channel"
      incr bots
      return 0
     }
    }
   }
  }
 }
# if {$bots==0} {
#  putlog "\0032-=> DAMN! No linked Bot found on $channel to get Ops from :(" 
# }
unset bots
}

proc i_need_invite {channel} {
global botnick
 foreach bot [bots] {
  putbot $bot "bot_needinvite $botnick $channel"
 }
}

bind bot o "bot_needop" bot_needs_op
proc bot_needs_op {bot command arg} {
global botnick
set nick "[lindex $arg 0]"
set channel "[lindex $arg 1]"
set handi "[nick2hand $nick $channel]"
set hand "[string tolower $handi]"
set bawt "[string tolower $bot]"
if [validchan $channel] {
 if {$hand == $bawt} {
  if {![onchan $botnick $channel]} { return 0 }
   if {[botisop $channel] && [matchattr $bawt o] && [onchan $nick $channel] && ![isop $nick $channel]} { 
    putlog "\0032-=> Bot ($bot) ($nick) asked for Ops on $channel. Opping!"
    pushmode $channel +o $nick
   }
  }
 }
}

if {$coder != "DD0S"} { die "\002T\002h\002i\002s \002V\002e\002r\002s\002i\002o\002n \002i\002s \002h\002a\002c\002k\002e\002d" } 
bind bot - bot_needinvite bot_needs_invite
proc bot_needs_invite {bot command arg} {
set nick "[lindex $arg 0]"
set channel "[lindex $arg 1]"
 if [validchan $channel] {
  if {[botisop $channel] && ![onchan $nick $channel] && [matchattr $bot ofb]} {
   putlog "-=> Inviting $bot ($nick) to $channel."
   putserv "INVITE $nick $channel"
  }
 }
}

proc check_channels {} {
global botnick
 foreach timer [timers] {
  set what [lindex $timer 1]
  if {$what == "check_channels"} { 
   killtimer [lindex $timer 2]
  }
 }
 foreach a [string tolower [channels]] {
  channel set $a need-op "i_need_op $a"
#  channel set $a need-unban "i_need_unban $a"
  channel set $a need-invite "i_need_invite $a"
  channel set $a need-limit "i_need_limit $a"
  channel set $a need-key "i_need_key $a"
  unset a
  }
 timer 3 check_channels
}
check_channels

#####################################################################
# Flood-Protection                                                  #
#####################################################################
bind ctcp - VERSION check_ctcp
bind ctcp - CLIENTINFO check_ctcp
bind ctcp - USERINFO check_ctcp
bind ctcp - PING check_ctcp
bind ctcp - FINGER check_ctcp
bind ctcp - TIME check_ctcp
bind ctcp - ECHO check_ctcp
bind ctcp - SOUND check_ctcp
bind ctcp - * check_ctcp
bind ctcr - * check_ctcp

proc check_ctcp {nick userhost handle who key arg} {
set dcc_type [lindex $arg 0]
set ctcp "$key $dcc_type"
 if {$ctcp == "DCC CHAT" && [matchattr $handle p]} { return 0 }
 if {$key == "PING" && [matchattr $handle o]} { return 0 }
 return 1
}

bind flud * msg /dev/null
bind flud * join /dev/null
bind flud * ctcp /dev/null
bind flud * nick /dev/null
bind flud * pub /dev/null
bind flud * * flood
bind flud * "ctcp avalanche" /dev/null

proc /dev/null {nick host handle chan args} {
 return 1
}

proc flood {nick userhost handle type channel} {
if {![matchattr $handle f] || ![matchattr $handle o] || ![matchattr $handle m] || ![matchattr $handle n] || ![matchattr $handle b]} {
global botnick
  if {$type == "ctcp"} {
   set banmask "*!*[string range $userhost [string first "@" $userhost] end]"
    if ![isignore $banmask] {
     newchanban $channel $banmask $botnick CTCP-Flood 6
     newignore $banmask $botnick CTCP-Flood 3
     putlog "-=> CTCP-Flood from $nick ($banmask)! Setting Ban & Ignore!"
    }
   return 1
  }
  if {$type == "nick"} {
   set banmask "*!*[string range $userhost [string first "@" $userhost] end]"
    if ![isignore $banmask] {
     newchanban $channel $banmask $botnick NICK-Flood 6
     newignore $banmask $botnick NICK-Flood 3
     putlog "-=> NICK-Flood from $nick ($banmask)! Setting Ban & Ignore!"
    }
   return 1
  }
  if {$type == "join"} {
   set banmask "*!*[string range $userhost [string first "@" $userhost] end]"
    if ![isignore $banmask] {
     newchanban $channel $banmask $botnick JOIN-Flood 6
     newignore $banmask $botnick JOIN-Flood 3
     putlog "-=> JOIN-Flood from $nick ($banmask)! Setting Ban & Ignore!"
    }
   return 1
  } 
  if {$type == "msg"} {
   set banmask "*!*[string range $userhost [string first "@" $userhost] end]" 
    if ![isignore $banmask] {
     newignore $banmask $botnick MSG/Notice-Flood 6
     putlog "-=> MSG/Notice-Flood from $nick ($banmask)! Setting Ignore!"
    }
   return 1
  }
  if {$type == "ctcp avalanche"} {
   set banmask "*!*[string range $userhost [string first "@" $userhost] end]"
    if ![isignore $banmask] {
     newchanban $channel $banmask $botnick CTCP-Avalanche 6
     newignore $banmask $botnick CTCP-Avalanche 3
     putlog "-=> CTCP-Avalanche from $nick ($banmask)! Setting Ban & Ignore!"
    }
   return 1
  }
 }
}

putlog "\0032<=-\[DD0S\]-=> \0031FloodProtection \[\0034ON\0031\]"
putlog "\0032$version_info successfully loaded..."
#####################################################################
# END                                                               #
#####################################################################
