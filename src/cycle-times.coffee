# Description:
#   Calculate Speticycle times.
#
# Dependencies:
#   Moment-timezone.js
#
# Configuration:
#   HUBOT_CYCLE_TIME_FMT: set the display format for times (uses Moment-timezone.js)
#   HUBOT_CYCLE_TZ_OFFSET: set the timezone offset (uses Moment-timezone.js)
#   HUBOT_CYCLE_TZ_NAME: set the timezone name (uses Moment-timezone.js) (name wins if set)
#
# Commands:
#   hubot septicycle|cycle [count]
#   hubot checkpoint|cp [count]
#   hubot cycle offset
#   hubot cycle set offset [offset]
#   hubot cycle set offsetname [offset name]
#
# Author:
#   impleri

moment = require "moment-timezone"

# Environment variables
timeFormat = process.env.HUBOT_CYCLE_TIME_FMT or "ddd hA"
tzOffset = process.env.HUBOT_CYCLE_TZ_OFFSET or moment().format("Z")
tzName = process.env.HUBOT_CYCLE_TZ_NAME

# Basic variables
checkpoint = 5 * 60 * 60 # 5 hours per checkpoint
checkpointsInCycle = 35
cycle = checkpoint * checkpointsInCycle
seconds = 1000

formatTime = (time) ->
    m = if tzName then moment(time).tz tzName  else moment(time).utcOffset tzOffset
    m.format " #{timeFormat}"

calculateNextCycle = (next = 1) ->
    now = new Date().getTime()
    start = seconds * cycle * Math.floor now / (cycle * seconds)
    start + cycle * seconds * next

getNextCycle = (next = 1) ->
    formatTime calculateNextCycle next


calculateNextCheckpoint = (next = 1) ->
    now = new Date().getTime()
    start = checkpoint * seconds * Math.floor now / (checkpoint * seconds)
    start + checkpoint * seconds * next

getNextCheckpoint = (next = 1) ->
    formatTime calculateNextCheckpoint next


calculateMuDifference = (ours, theirs) ->
    nextCycle = calculateNextCycle 1
    nextCheckpoint = calculateNextCheckpoint 1
    timeRemaining = (nextCycle - nextCheckpoint) / seconds
    checkpointsRemaining = timeRemaining / checkpoint
    checkpointsDone = checkpointsInCycle - checkpointsRemaining
    ourScore = checkpointsInCycle * ours / checkpointsDone
    theirScore = checkpointsInCycle * theirs / checkpointsDone
    difference = theirScore - ourScore
    difference = 0 if difference < 1
    difference + 1

getMuNeededNow = (ours, theirs) ->
    calculateMuDifference ours, theirs

getMuNeededAverage = (ours, theirs) ->
    nextCycle = calculateNextCycle 1
    nextCheckpoint = calculateNextCheckpoint 1
    timeRemaining = (nextCycle - nextCheckpoint) / seconds
    checkpointsRemaining = timeRemaining / checkpoint
    difference = calculateMuDifference ours, theirs
    Math.ceil difference / checkpointsRemaining


module.exports = (robot) ->
  robot.respond /cycle offset/i, (msg) ->
    offset = tzName or tzOffset
    msg.send "Current timezone offset is #{offset}."

  robot.respond /(septi)?cycle\s*([0-9])?$/i, (msg) ->
    count = +msg.match[2]
    count = 1 unless count > 1
    times = []
    times.push getNextCycle number for number in [1..count]
    msg.send "The next #{count} cycle(s) occur at: #{times}."

  robot.respond /c(heck)?p(oint)?\s*([0-9])?/i, (msg) ->
    count = +msg.match[3]
    count = 1 unless count > 1
    times = []
    times.push getNextCheckpoint number for number in [1..count]
    msg.send "The next #{count} checkpoint(s) occur at: #{times}."

  robot.respond /m(ind\s*)?u(nits?)?( needed)?\s+([0-9]+k?)\s+([0-9]+k?)/i, (msg) ->
    ours = +msg.match[4]
    ours = 1000 * +msg.match[4].slice 0, -1 if "k" is msg.match[4].slice -1
    ours = 0 unless ours > 0
    theirs = +msg.match[5]
    theirs = 1000 * +msg.match[5].slice 0, -1 if "k" is msg.match[5].slice -1
    theirs = 0 unless theirs > 0
    needed = getMuNeededNow ours, theirs
    msg.send "We need #{needed} MU to win the cycle."

  robot.respond /m(ind\s*)?u(nits?)? average\s+([0-9]+k?)\s+([0-9]+k?)/i, (msg) ->
    ours = +msg.match[3]
    ours = 1000 * +msg.match[3].slice 0, -1 if "k" is msg.match[3].slice -1
    ours = 0 unless ours > 0
    theirs = +msg.match[4]
    theirs = 1000 * +msg.match[4].slice 0, -1 if "k" is msg.match[4].slice -1
    theirs = 0 unless theirs > 0
    needed = getMuNeededAverage ours, theirs
    msg.send "We need to increase our MU by #{needed} per checkpoint to win the cycle."
