#!/usr/bin/env perl
# yandeli

use Date::Parse;
use List::Util qw[min max];
use POSIX qw(strftime);

$thread_hold = -100000000;
if ( $ARGV[0] eq '-d' ) {
    shift;
    $thread_hold=$ARGV[0];
    shift;
}

$push = grep {$_ eq '-p'} @ARGV;
$delay_ana = grep {$_ eq '-c'} @ARGV;
$cmd_out = grep {$_ eq '-o'} @ARGV;
$log = grep {$_ eq '-l'} @ARGV;
$simple = grep {$_ eq '-s'} @ARGV;
undef @ARGV;


# TITLE
print join ("|", "T", "FLAG", "KEY", "USER", "T2",  "DIFF", "DETAIL", "\n" );

# CMD-IN detail blacklist
@blacklist = qw(
 GetMultiPlayerInfo
 GetChatNewMail
 ReadMail
 Pay
 PayReason
 MailRewardBatch
 SendRtsFightResultPataHandler
 BatchClientRequestHandler
 SaveUserFormationInformationHandler
 DeleteBatch
 ItemDel
 ReadReportHandler
 RtsPvpIslandSetHandler
);

# CMD-OUT detail whitelist
@whitelist = qw(
  Pay
  PayIOS
);

# 登陆被动请求列表
@passive_list = qw(
 KingScoreLoginNew                      king.score.login.new
 GetDynamicTaskInfoHandler              get.dynamic.task.info
 OpenMonsterCrusadeCampHandler          open.monster.crusade.camp
 GetChatNewMail                         chat.get.new.mails
 GetChatNewsHandler                     get.chat.news
 DailySpecialOpenHandler                user.daily.special.open
 GetSignInInfo                          signIn.info
 EnterRtsWorldPataHandler               rts.enter.world.pata
 GetAssistInfoHandler                   rts.war.game.assist.info
 GetAllianceTask2InfoHandler            get.al.task.info.new
 GetAllianceBossInfoHandler             get.alliance.boss.info
 SandArenaStoreInfo                     sand.arena.store.info
 AllianceTreasureBoxListHandler         alliance.treasure.box.list
 GetAllianceTreasureBoxTipHandler       alliance.treasure.box.tip
 HeroWeaponInfoHandler                  hero.weapon.info
 GetAchievements                        achieve.ls
 AllianceTreasureBoxSelfHandler         alliance.treasure.box.self
 AllianceTreasureBoxHelpListHandler     alliance.treasure.box.help.list
 GetDailyTask2InfoHandler               get.daily.task
 GetScienceInfo                         science.data.init
 GetWorldServerList                     cross.server.ls
 ShowStatusItem                         show.status.item
 GetAirForceScienceInfo                 airforce.science.data.init
 GetMultiPlayerInfo                     get.user.info.multi
 SetTutorial                            stat.tt
 LightDarkItemInfoHandler               light.dark.item.info
 OpenGiftPanelNewPlayerHandler          thanksgiving.gift.open.newplayer
 CrazyRobotListHandler                  crazy.robot.list
 LeagueRankInfoHandler                  league.rank.info
);

while(<>) {
        $T = $FLAG = $KEY = $USER = $T2 = $DIFF = $DETAIL = undef;

        @A = split / \| /, $_;
        $T = @A[0];
        $KEY = @A[6];
        $USER = @A[7];

        if ($_ =~ m/(?:CMD|EVENT)-IN.*"COMMAND_ID":"(\d+)/) {
            @T = split /,/, $T;
            $t = str2time(@T[0]) . @T[1];
            $c_time = $1;
            $1 < 1400000000000 && ($c_time .= "000");

            $d_time = $t - $c_time;
            $DIFF = diff_suffix($d_time, 5000);

            $T2 = from_unixtimestamp($c_time);

            if ($_ =~ /CMD-IN/ && @A > 9) {
                @A[8] = join "#", @A[8..(@A - 1)];
            }

            $FLAG = "<CI>";
            if ($KEY =~ /ClientDebugHandler/) {
                $DETAIL = strip_cmd_in(@A[8]);
                $FLAG = "<D>";
            } elsif ($KEY =~ /GetWorldInfo/ ) {
                ($t) = @A[8] =~ /"type":(\d+)/;
                ($s) = @A[8] =~ /"serverId":(\d+)/;
                ($x) = @A[8] =~ /"x":(\d+)/;
                ($y) = @A[8] =~ /"y":(\d+)/;
                $DETAIL = $t . "," . (defined $s ? $s . ": " : "") . "[" . $x . "," . $y . "]";
            } elsif ($KEY =~ /GetWorldPointDetail/) {
                ($t) = @A[8] =~ /"point":(\d+)/;
                ($s) = @A[8] =~ /"serverId":(\d+)/;
                $DETAIL = "-," . (defined $s ? $s . ": " : "") . get_xy($t);
            } elsif ($KEY =~ /UseItem/) {
                ($i) = @A[8] =~ /(?:"itemId":"|"itemid":)(\d+)/;
                if (! defined $i) { ($i) = @A[8] =~ /(?:"bu_id":)(\d+)/; $i = "!" . $i}
                ($n) = @A[8] =~ /"num":(\d+)/;
                ($ref) = @A[8] =~ /"ref":"([^"]+)/;
                $DETAIL = $i . "*" . $n . "," . $ref;
            } elsif ($KEY =~ /MarchWorldPoint$/) {
                ($i) = $_ =~ /"f_id":(\d+)/;
                ($s) = $_ =~ /"f_s":(\d+)/;
                defined $i && ($DETAIL = "Format: " . $i . "," . $s);
            } elsif ($KEY =~ /BindingAccountHandler/) {
                $DETAIL = strip_cmd_in(@A[8]);
                $DETAIL =~ s/"\w+":"",?//g;
            } elsif ($KEY =~ /LoginEventHandler/) {
# {
#     "appVersion":"3.3.0"
#     "using-proxy":"False",
# --" channel": "ams_gp",
#     "pid": 8448,
#     "networktype": "wifi",
#     "deviceId": "c85131bd3bbb4155_hg_ams_gp",
# --  "platform": "1",
# --  "packageName": "com.hts.ams",
#     "lang": "en",
#     "fromCountry": "US",
# --  "os": "Android OS 9 / API-28 (PPR1.180610.011/T387VVRU1BSG7)",
# --  "pf": "hg_ams_gp",
#     "launchByPush": 0
# }

                $DETAIL = join ",", grep { $_ ne '' } $_ =~ /((?:"appVersion":"|"using-proxy":"|"pid":|"deviceId":"|"lang":"|"fromCountry":"|"launchByPush":|"session_id":|"loginReason":"|"graphicmemory\\":|"memory\\":\\")(?:[\w.]+"?)|(?:"networktype"|"os")(?::"[^"]+"))/g;
                $DETAIL =~ s/\\//g;
            } elsif ($KEY =~ /PayIOS/) {
                $DETAIL = strip_cmd_in(@A[8]);
                $DETAIL =~ s/"sSignedData":"[^"]+"//;
            } elsif ( grep { $_ eq $KEY} @blacklist ) {
                $DETAIL = "..."
            } else {
                $DETAIL = strip_cmd_in(@A[8]);
            }

            if ($d_time >= $thread_hold) {
                print_item($T, $FLAG, $KEY, $USER, $T2, $DIFF, $DETAIL);

                # 分析 cmd_delay
                if ($delay_ana > 0) {
                    my ($s) = @A[8] =~ /cmd_delay([^]]*)]/;
                    while ($s =~ /(?:"st":(\d+),"ct":\d+,"r":\d+,)?+"c":"([\w.]+)","d":([-\d]+),(?:"t":(\d+))?([^}]+)/g) {
                        if ($2) {
                            $KEY = $2;
                            $DIFF = diff_suffix($3, 3000);
                            $T2 = $1 ? from_unixtimestamp($1) : $4 ? from_unixtimestamp($4) : "-";
                            if (!$simple) {
                                $DETAIL = $5;
                                $DETAIL =~ s/"s1":\d+,?|"s2":\d+,?//g;
                            } else {
                                $DETAIL = undef;
                            }
                            print_item("-", "<CR>", $KEY, $USER, $T2, $DIFF, $DETAIL);
                        }
                    }

                    while ($s =~ /"p":"([\w.]+)","st":(\d+),"ct":(\d+)/g) {
                        if ($1) {
                            $T2 = from_unixtimestamp($2);
                            $DIFF = diff_suffix($3 - $2, 3000);
                            print_item("-", "<PR>", $1, $USER, $T2, $DIFF);
                        }
                    }
                }
            }
        }

        # CMD-OUT
        elsif ($cmd_out > 0 && $_ =~ m/(?:CMD|EVENT)-OUT \| (?!ClientDebugHandler)/) {
            # synchronize
            if (@A[9] =~ /^\s*synchronize user.*same command/ ) {
                $DIFF = "*S*";
            } elsif ($_ =~ /user is cross, swallow/) {
                $DIFF = "*C*";
            } elsif ($_ =~ /processing block!/) {
                $DIFF = "*B*";
            } elsif ((@A == 12 || @A == 13) && @A[9] =~ /^\s*[-\w]+\s*$/ ) {
                # exception code
                $DIFF = @A[9];
                $DETAIL = @A[10];
            } elsif (@A[9] =~ /^\s*exception\s*$/) {
                $DIFF = "E000000";
                $DETAIL = "unchecked exception";
            } else {
                # diff
                $DIFF = @A[8];
                # $DIFF =~ s/^\s+|\s+$//g;
                $DIFF = diff_suffix($DIFF, 500);

                if (length @A[9] < 200) {
                    $DETAIL = strip_cmd_in(@A[9]);
                } else {
                    $DETAIL = "......";
                }
            }

            # gold, power
            if ($_ =~ /EVENT-OUT/) {

            } else {
                $t = @A[-1];
                ($T2 = @A[-1]) =~ s/{.*"gold":(\d+).*"payGold":(\d+).*/$1+$2/e;
                # @A[-1] =~ s/^\s+|\s+$//g;
                # $T2 = @A[-1];
                $T2 = trim($T2);
                $t =~ /"power"/ && (($p) = $t =~ /"power":(\d+)/);
                defined $p && ($T2 .= "," . $p);
           }
            print_item($T, "<CO>", $KEY, $USER, $T2, $DIFF, $DETAIL);
        }

        # PUSH
        elsif ($push > 0 && @A[5] eq "PUSH" && @A[7] =~ m/\-\d{6,}/) {
            if ($KEY =~ /push.world.march.return|push.enemy.report/ ) {
                $_ =~ m/"uuid":"(\w+)"/;
                $DETAIL = $1;
            } elsif ($_ =~ m/push.world.march/) {
                $DETAIL = world_march_detail(@A[-1]);
            } elsif ($KEY eq "init") {
                # point
                ($DETAIL) = $_ =~ /.*,"world":.*?,"point":(\d+).*/;
                $DETAIL = get_xy($DETAIL);
            }

            if (defined $DETAIL) {
                print_item($T, "<P>", $KEY, $USER, "-", "-", $DETAIL);
            } else {
                print_item($T, "<P>", $KEY, $USER);
            }
        }

        # GROUP PUSH & FINALLY PUSH
        elsif ($push > 0 && $_ =~ m/ PUSH .* \d+, /) {
            if ($_ =~ /FINALLY/) {
                ($KEY) = $_ =~ /"pushCMD":"([^"]+)/;
                print_item($T, "<FP>", $KEY);
            } else {
                if ($KEY =~ /push.world.get/) {
                    ($DETAIL) = @A[-1] =~ /"i":(\d+)/;
                    ($name) = @A[-1] =~ /"o":"(\w*)/;
                    ($pt) = @A[-1] =~ /"pt":(\d+)/;
                    $DETAIL = get_xy($DETAIL) . (length($name) > 0 ? (" name:" . $name) : "") . ($pt > 0 ? (" pt:" . $pt) : "");
                } elsif ($KEY =~ /push.world.march/) {
                    $DETAIL = world_march_detail(@A[-1]);
                }

                if (defined $DETAIL) {
                    print_item($T, "<GP>", $KEY, " ", " ", " ", $DETAIL);
                } else {
                    print_item($T, "<GP>", $KEY);
                }
            }
        }

        # DISCONNECT
        elsif ($_ =~ m/DISCONNECT SESSION LOG/) {
            $DETAIL = join ",", @A[-1] =~ /(?:sessionId:|address:|disconnectReason:)\s*([^ ]+)/g;
            $USER = @A[6];
            print_item($T, "<E>", "--DISCONNECT--", $USER, "↑↑↑↑", "↑↑↑↑", $DETAIL);
        }

        # LOGIN
        elsif ($_ =~ m/User login.*User Name: (\d+), Id: (\d+).* Sess: ([^ ]+).*Type: (.*)/) {
            $DETAIL = $3 . "," . $4;
            print_item($T, "<E>", "--LOGIN--", $1, "↓↓↓↓", "↓↓↓↓", $DETAIL);
        }

        # move city log
        elsif ($log > 0 && $_ =~ m/move city (\d+) from (\d+).*to (\d+)/) {
            $DETAIL = get_xy($2) . " -> " . get_xy($3);
            print_item($T, "<L>", "MOVE CITY", $1, "-", "-", $DETAIL);
        }

        # aws push log
        elsif ($log > 0 && $_ =~ m/aws_push:parse no valid(.*)! uid:(\d+), pushType:(.*)/) {
            $DETAIL =  $1. "->".$3;
            print_item($T, "<L>", "AWS PUSH FAIL", $2, "-", "-", $DETAIL);
        }

}



sub get_xy {
    $x= ($_[0] % 16777216) % 4096;
    $y= int(($_[0] % 16777216) / 4096);
    return "[" . $x . "," . $y . "]";
}

sub world_march_detail {
    ($uuid) = $_[0] =~ /"uuid":"(\w+)/;
    ($sp) = $_[0] =~ /"sp":(\d+)/;
    ($dp) = $_[0] =~ /"dp":(\d+)/;
    ($tType) = $_[0] =~ /"tType":(\d+)/;
    $DETAIL = defined $uuid ? ($uuid . (defined $sp ? (" # " . get_xy($sp) . " -> " . get_xy($dp)) . " # " . $tType : "")) : "";
    return $DETAIL;
}

sub print_item {
    # print join ("|", "T", "FLAG", "KEY", "USER", "T2",  "DIFF", "DETAIL", "\n" );

    my @array = @_;
    foreach my $i (@array) {
        if (! defined $i) {
            $i = " ";
        } elsif ($i =~ /^\s*$/) {
           $i = " ";
        } else {
           $i = trim($i);
           $i =~ s/\|/#/g;
        }
    }

    # passive request special mark *
    if (grep { $_ eq @array[2]} @passive_list) {
        if (!$simple) {
           @array[2] = "*" . @array[2] . "*"
        } else {
            return;
        }
    };
    print join "|",  @array, "\n";
}

sub diff_suffix {
    # $_[0]: diff; $_[1]: frequence_ratio
    $d = $_[0];
    $fre = min(8, int($_[0] / $_[1]));
    $d > $_[1] && ($d .= " <" . ("-" x $fre));
    return $d;
}

sub trim {
    $str = $_[0];
    $str =~ s/^\s*,?\s*|\s*,?\s*$//g;
    return $str;
}

sub from_unixtimestamp {
    return (strftime '%T', gmtime($_[0]/1000)) . "," . substr($_[0], -3);
}

sub strip_cmd_in {
    $str = $_[0];
    $str =~ s/^\s*{|}\s*$|"(_sib|idle)":[^,]+,?|"cmd_delay":[^]]+],?|"(crc|COMMAND_ID|c_record)":"[^"]+",?|"clientTime":\w+,?//g;       # strip
    # $str =~ s/^,|,$//g;
    return $str;
}
