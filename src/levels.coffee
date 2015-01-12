# Description
#   Ingress helper commands for Hubot
#
# Dependencies:
#   None
#
# Commands:
#   hubot AP until|to <N> - tells you the AP required for N level
#   hubot AP all - prints the AP requirements for each level
#
# Author:
#   therealklanni

# Quick refrence for what badges are need at what level
# LVL   Badges              AP          Max xm
# 9   4 Silver, 1 Gold,     2400000,    10900
# 10  5 Silver, 2 Gold,     4000000,    11700
# 11  6 Silver, 4 Gold,     6000000,    12400
# 12  7 Silver, 6 Gold,     8400000,    13000
# 13  7 Gold, 1 Plat,       12000000,   13500
# 14  2 Plat,               17000000,   13900
# 15  3 Plat,               24000000,   14200
# 16  4 Plat, 2 Black,      40000000,   14400

levels =
  1:
    ap: 0
    xm: 3000
  2:
    ap: 2500
    xm: 4000
  3:
    ap: 20000
    xm: 5000
  4:
    ap: 70000
    xm: 6000
  5:
    ap: 150000
    xm: 7000
  6:
    ap: 300000
    xm: 8000
  7:
    ap: 600000
    xm: 9000
  8:
    ap: 1200000
    xm: 10000
  9:
    ap: 2400000
    xm: 10900
    badges:
      silver: 4
      gold: 1
  10:
    ap: 4000000
    xm: 11700
    badges:
      silver: 5
      gold: 2
  11:
    ap: 6000000
    xm: 12400
    badges:
      silver: 6
      gold: 4
  12:
    ap: 8400000
    xm: 13000
    badges:
      silver: 7
      gold: 6
  13:
    ap: 12000000
    xm: 13500
    badges:
      gold: 7
      platinum: 1
  14:
    ap: 17000000
    xm: 13900
    badges:
      platinum: 2
  15:
    ap: 24000000
    xm: 14200
    badges:
      platinum: 3
  16:
    ap: 40000000
    xm: 14400
    badges:
      platinum: 4
      black: 2

module.exports = (robot) ->
  quantifyBadges = (a) ->
    for kind, n of a
      ":#{kind}:#{if n > 1 then '×' + n else ''}"

  robot.respond /AP\s+(?:to|(?:un)?til)\s+L?(\d\d?)/i, (msg) ->
    [lv, lvl] = [msg.match[1], levels[msg.match[1]]]
    if lvl.badges?
      badgeReq = quantifyBadges lvl.badges
    msg.reply "A total of #{lvl.ap} AP#{if badgeReq? then ' ' + badgeReq.join ' ' else ''}
 is needed to reach L#{lv}#{if lv > 15 then ' (hang in there!)' else ''}"

  robot.respond /AP all/i, (msg) ->
    lvls = for lv, lvl of levels
      if lvl.badges?
        badgeReq = quantifyBadges lvl.badges
      "\nL#{lv} = #{lvl.ap} AP#{if badgeReq? then ' ' + badgeReq.join ' ' else ''}"
    msg.send lvls.join ""
