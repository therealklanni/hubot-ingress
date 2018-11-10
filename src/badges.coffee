# Description
#   Ingress helper commands for Hubot
#
# Dependencies:
#   None
#
# Commands:
#   hubot I have the <badge> badge - add/remove badges (say don't to remove)
#   hubot I don't have any badges - remove your badges completely
#   hubot what badges do I have? - show off your Ingress badges—you worked hard for them!
#   hubot what badges does <person> have? - check another agent's badges
#   hubot list badges - list the badges available
#   hubot display badges - displays all the badge titles and the badges
#
# Author:
#   therealklanni
# Maintainer:
#   drh4kor


badgeList = [
  'abaddon',
  'acolyte',
  'acolyte-2017',
  'acolyte-2018',
  'ada-2016',
  'ada-2017',
  'ada',
  'aegis-nova',
  'akira-tsukasa',
  'akira-2017',
  'builder1', 'builder2', 'builder3', 'builder4', 'builder5',
  'campbell-2018',
  'cassandra-prime',
  'connector1', 'connector2', 'connector3', 'connector4', 'connector5',
  'darsana',
  'devra-bogdanovich',
  'devra-2017',
  'edgar-allan-wright',
  'engineer1', 'engineer2', 'engineer3', 'engineer4', 'engineer5',
  'eve',
  'exo-five',
  'exo51','exo51','exo51','exo51',
  'explorer1', 'explorer2', 'explorer3', 'explorer4', 'explorer5',
  'founder',
  'goruck',
  'goruck-stealth',
  'goruck-urban',
  'guardian1', 'guardian2', 'guardian3', 'guardian4', 'guardian5',
  'hacker1', 'hacker2', 'hacker3', 'hacker4', 'hacker5',
  'hank-johnson',
  'hank-johnson-2016',
  'hankjohnson-prime-2018',
  'hank-2017',
  'hank-2018',
  'helios',
  'illuminator1', 'illuminator2', 'illuminator3', 'illuminator4','illuminator5',
  'initio',
  'innovator1', 'innovator2', 'innovator3', 'innovator4', 'innovator5'
  'intelops',
  'interitus',
  'jahan',
  'jarvis-prime-2018',
  'klue',
  'klue-2016',
  'kodama-2017',
  'kodama-smiles',
  'liberator1', 'liberator2', 'liberator3', 'liberator4', 'liberator5',
  'luminary1', 'luminary2', 'luminary3', 'luminary4', 'luminary5',
  'magnus1', 'magnus2',
  'mindcontroller1', 'mindcontroller2', 'mindcontroller3', 'mindcontroller4', 'mindcontroller5',
  'missionday1', 'missionday2', 'missionday3', 'missionday4', 'missionday5',
  'mistyhannah-2017',
  'neutralizer1','neutralizer2','neutralizer3',
  'nl-1331',
  'nl-1331-2016',
  'nl-1331e-2017',
  'nl-1331e'
  'nl-1131-meetup1','nl-1131-meetup2','nl-1131-meetup3','nl-1131-meetup4','nl-1131-meetup5',
  'nl-prime',
  'nla-2017',
  'nlprime-2017',
  'olw-2017',
  'olw-2018',
  'olw-prime-2018',
  'oliver-lynton-wolfe',
  'oliver-lynton-wolfe-2016',
  'one-three-magnus',
  'obsidian',
  'operationclearfield',
  'operationclearfield-2018',
  'oprlive',
  'osiris',
  'pachapeau-2017',
  'pachapeau-2018',
  'pachapeau-prime-2018',
  'p-a-chapeau', 'p-a-chapeau-2016',
  'persepolis',
  'pioneer1', 'pioneer2', 'pioneer3', 'pioneer4', 'pioneer5',
  'prime',
  'primechallenge',
  'purifier1', 'purifier2', 'purifier3', 'purifier4', 'purifier5',
  'recharger1', 'recharger2', 'recharger3', 'recharger4', 'recharger5',
  'recon1','recon2','recon3','recon4','recon5',
  'recursion',
  'recruiter0', 'recruiter1', 'recruiter2', 'recruiter3', 'recruiter4', 'recruiter5',
  'sage1','sage2','sage3','sage4','sage5',
  'seer1', 'seer2', 'seer3', 'seer4', 'seer5',
  'shonin',
  'simulacrum',
  'sojourner1', 'sojourner2', 'sojourner3', 'sojourner4', 'sojourner5',
  'specops1', 'specops2', 'specops3', 'specops4', 'specops5',
  'stella-vyctory',
  'susanna-moyer',
  'susanna-moyer-2016',
  'trekker1', 'trekker2', 'trekker3', 'trekker4', 'trekker5',
  'translator1', 'translator2', 'translator3', 'translator4', 'translator5',
  'verified',
  'vanguard1', 'vanguard2', 'vanguard3', 'vanguard4', 'vanguard5'
  'via-lux-adventurer',
  'via-lux-odyssey',
  'via-lux',
  'via-noir'
]

badgeNameUpdateVersion = 1

badgeNameUpdateMap = {
  'ada-1': 'ada'
  'ada-2': 'ada-2016'
  'aegis': 'aegis-nova'
  'akira': 'akira-tsukasa'
  'devra-1': 'devra-bogdanovich'
  'goruckstealh': 'goruck-stealth'
  'goruckurban': 'goruck-urban'
  'nl-1331-1': 'nl-1331'
  'nl-1331-2': 'nl-1331-2016'
  'oliver-lynton-wolfe-2': 'oliver-lynton-wolfe-2016'
  'p-a-chapeau-2': 'p-a-chapeau-2016'
  'susanna-moyer1': 'susanna-moyer'
  'susanna-moyer2': 'susanna-moyer-2016'
}

colorList= {
  '': '',
  'locked': 0,
  'bronze': 1,
  'silver': 2,
  'gold': 3,
  'platinum': 4,
  'black': 5,
  'onyx': 5
}

badgeTypes = {
  'abaddon': 1,
  'acolyte': 1,
  'acoloyte-2017': 1,
  'acoloyte-2018': 1,
  'ada': 1,
  'ada-2016': 1,
  'ada-2017': 1,
  'aegis-nova': 1,
  'akira-tsukasa': 1,
  'akira-2017': 1,
  'builder': 5,
  'campbell-2018': 1,
  'cassandra-prime': 1,
  'connector': 5,
  'darsana': 1,
  'devra-bogdanovich': 1,
  'devra-2017': 1,
  'edgar-allan-wright': 1,
  'engineer': 5,
  'eve': 1,
  'explorer': 5,
  'exo-five': 1,
  'exo5': 5,
  'founder': 1,
  'goruck': 1,
  'goruck-stealth': 1,
  'goruck-urban': 1,
  'guardian': 5,
  'hacker': 5,
  'hank-johnson': 1,
  'hank-johnson-2016': 1,
  'hankjohnson-prime-2018': 2,
  'hank-2017': 1,
  'hank-2018': 1,
  'helios': 1,
  'illuminator': 5,
  'initio': 1,
  'innovator': 5,
  'intelops': 1,
  'interitus': 1,
  'jahan': 1,
  'jarvis-prime-2018': 1,
  'klue': 1,
  'klue-2016': 1,
  'kodama-2017': 1,
  'kodama-smiles': 1,
  'liberator': 5,
  'luminary': 5,
  'mindcontroller': 5,
  'missionday': 5,
  'mistyhannah-2017': 1,
  'neutralizer': 3,
  'nl-1331': 1,
  'nl-1331-2016': 1,
  'nl-1331e-2017': 1,
  'nl-1331e': 1,
  'nl-1131-meetup': 5,
  'nl-prime': 1,
  'nla-2017': 1,
  'nlprime-2017': 1,
  'olw-2017': 1,
  'olw-2018': 1,
  'oliver-lynton-wolfe': 1,
  'oliver-lynton-wolfe-2016': 1,
  'olw-prime-2018': 1,
  'one-three-magnus': 1,
  'obsidian': 1,
  'operationclearfield': 1,
  'operationclearfield-2018': 1,
  'oprlive': 1,
  'osiris': 1,
  'pachapeau-2017': 1,
  'pachapeau-2018': 1,
  'pachapeau-prime-2018': 1,
  'p-a-chapeau': 1,
  'p-a-chapeau-2016': 1,
  'persepolis': 1,
  'pioneer': 5,
  'prime': 1,
  'primechallenge', 1,
  'purifier': 5,
  'recharger': 5,
  'recon': 5,
  'recursion': 1,
  'recruiter': 5,
  'sage': 5,
  'seer': 5,
  'shonin': 1,
  'simulacrum':1,
  'sojourner': 5,
  'specops': 5,
  'stella-vyctory': 1,
  'susanna-moyer': 1,
  'susanna-moyer-2016': 1,
  'trekker': 5,
  'translator': 5,
  'verified': 1,
  'vanguard': 5
  'via-lux-adventurer': 1,
  'via-lux-odyssey': 1,
  'via-lux': 1,
  'via-noir': 1
}

module.exports = (robot) ->
  badges =
    add: (user, badgeNames...) ->
      for badgeName in badgeNames
        # only replace tiered badges - allows having all of the character badges
        if not badgeTypes[badgeName]?
          toRemove = badgeList.filter (x) ->
            (x.replace /\d+/, '') is (badgeName.replace /\d+/, '')
          @del user, badge for badge in toRemove
        userBadges = robot.brain.data.ingressBadges[user.id] ?= []
        userBadges.push ":#{badgeName}:" unless ":#{badgeName}:" in (badges.forUser user)
    del: (user, badgeName) ->
      robot.brain.data.ingressBadges[user.id] = (badges.forUser user).filter (x) ->
        x isnt ":#{badgeName}:"
    updateNames: ->
      robot.brain.data.ingressBadgeNameUpdateVersion ?= 0
      if robot.brain.data.ingressBadgeNameUpdateVersion < badgeNameUpdateVersion
        for userId, userBadges of robot.brain.data.ingressBadges
          for oldBadgeName, newBadgeName of badgeNameUpdateMap
            index = userBadges.indexOf ":#{oldBadgeName}:"
            userBadges[index] = ":#{newBadgeName}:" if index isnt -1
        robot.brain.data.ingressBadgeNameUpdateVersion = badgeNameUpdateVersion
    clear: (user) ->
      robot.brain.data.ingressBadges[user.id] = []
    forUser: (user) ->
      robot.brain.data.ingressBadges[user.id] ?= []

  robot.brain.on 'loaded', ->
    robot.brain.data.ingressBadges ?= {}
    badges.updateNames()

  robot.respond /(@?[.\w\-]+) (?:have|has|got|earned)(?: the)? :?([\-\w,\s]+):? badges?/i, (msg) ->
    who = msg.match[1].toLowerCase().replace '@', ''
    badgeNames = (msg.match[2].toLowerCase()).split ','

    if who == 'i'
      who = msg.envelope.user
    else
      who = robot.brain.userForName who

    invalidNames = []
    validNames = []
    for rawBadgeName in badgeNames
      colorNames = Object.keys(colorList).join '|'
      badgeNameParts = rawBadgeName.match /// ^
        \s* # Leading spaces
        (#{colorNames})?
        \s* # Actual space
        ([\-\w]+) # Badge Name
        \s* # Trailing space
        $ ///i

      continue unless badgeNameParts?
      badgeName = badgeNameParts[2].toLowerCase()

      colorName = 'bronze'
      colorName = badgeNameParts[1] if badgeNameParts[1]
      colorName = '' if badgeName in badgeList

      badgeName += colorList[colorName.toLowerCase()]

      if badgeName in badgeList
        validNames.push badgeName
      else
        invalidNames.push badgeName

    msg.reply "invalid badge name(s): #{invalidNames.join ', '}." if invalidNames.length > 0

    if validNames.length > 0
      for badgeName in validNames
        badges.add who, badgeName

      userBadges = badges.forUser who
      validNames = validNames.filter (x) ->
        ":#{x}:" in userBadges

      if who.name == msg.envelope.user.name
        msg.reply "congrats on earning the :#{validNames.join ': :'}:
 badge#{if validNames.length > 1 then 's' else ''}!"
      else
        msg.send "@#{who.name}: congrats on earning the :#{validNames.join ': :'}:
 badge#{if validNames.length > 1 then 's' else ''}!"

  robot.respond /wh(?:at|ich) badges? do(?:es)? (@?[.\w\-]+) have/i, (msg) ->
    who = msg.match[1].replace '@', ''

    if who.toLowerCase() == 'i'
      who = msg.envelope.user
    else
      who = robot.brain.userForName who

    userBadges = badges.forUser who
    you = if who? and who.name == msg.envelope.user.name then true else false
    whowhat = "#{if you then 'You have' else who.name + ' has'}"

    if who? and userBadges.length > 0
      msg.reply "#{whowhat} the following badges: #{userBadges.join ' '}"
    else
      msg.reply "#{whowhat} no badges."

  robot.respond /(@?[.\w\-]+) (?:do(?:n't|esn't| not)) have the :?([\-\w]+):? badge/i, (msg) ->
    who = msg.match[1].toLowerCase().replace '@', ''
    badgeName = msg.match[2].toLowerCase()

    if who == 'i'
      who = msg.envelope.user
    else
      who = robot.brain.userForName who

    if ":#{badgeName}:" in badges.forUser who
      badges.del who, badgeName
      msg.reply "removed the :#{badgeName}: badge"

  robot.respond /I (?:do(?:n't| not)) have any badges?/i, (msg) ->
    badges.clear msg.envelope.user
    msg.reply 'OK, removed all your badges'

  robot.respond /list badges ?.*/i, (msg) ->
    message = ""
    for badgeType of badgeTypes
      message += "#{badgeType}, "
    msg.send message

  robot.respond /display badges ?.*/i, (msg) ->
    message = "The available badges are:\n"
    for badgeType, badgeNum of badgeTypes
      if badgeNum == 1
        message += "#{badgeType}: :#{badgeType}: \n"
      else if badgeNum == 5
        message += "#{badgeType}: :#{badgeType}1: :#{badgeType}2: :#{badgeType}3: :#{badgeType}4: :#{badgeType}5: \n"
      else if badgeNum == 6
        message += "#{badgeType}: :#{badgeType}0: :#{badgeType}1: :#{badgeType}2: :#{badgeType}3: :#{badgeType}4: :#{badgeType}5: \n"
    msg.send message
