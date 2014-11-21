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
checkpoint = 5*60*60 # 5 hours per checkpoint
cycle = checkpoint * 35 # 35 checkpoints per cycle
seconds = 1000

formatTime = (time) ->
    m = if tzName then moment(time).tz(tzName) else moment(time).zone(tzOffset)
    m.format " #{timeFormat}"

getNextCycle = (next = 1) ->
    now = new Date().getTime()
    start = seconds * cycle * Math.floor now / (cycle * seconds)
    time = start + cycle * seconds * next
    formatTime(time)

getNextCheckpoint = (next = 1) ->
    now = new Date().getTime()
    start = checkpoint * seconds * Math.floor now / (checkpoint * seconds)
    time = start + checkpoint * seconds * next
    formatTime(time)

module.exports = (robot) ->
  robot.respond /cycle offset/i, (msg) ->
    offset = tzName or tzOffset
    msg.send "Current timezone offset is #{offset}."

  robot.respond /cycle set offset (.*)/i, (msg) ->
    tzOffset = msg.match[1]
    msg.send "Timezone offset is set to #{tzOffset}. I hope you know what you are doing."

  robot.respond /cycle set offsetname (.*)/i, (msg) ->
    tzOffset = msg.match[1]
    msg.send "Timezone offset name is set to #{tzName}. I hope you know what you are doing."

  robot.respond /(septi)?cycle\s*([0-9])?/i, (msg) ->
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
