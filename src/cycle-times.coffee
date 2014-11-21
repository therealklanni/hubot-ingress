# Description:
#   Calculate Speticycle times.
#
# Dependencies:
#   Moment.js
#
# Configuration:
#   HUBOT_CYCLE_TIME_FMT: set the display format for times (uses Moment.js)
#   HUBOT_CYCLE_TZ_OFFSET: set the timezone offset (uses Moment.js)
#
# Commands:
#   hubot septicycle|cycle [count]
#   hubot checkpoint|cp [count]
#   hubot cycle offset
#   hubot cycle set offset [offset]
#
# Author:
#   impleri

moment = require "moment"

# Environment variables
timeFormat = process.env.HUBOT_CYCLE_TIME_FMT or "ddd hA"
tzOffset = process.env.HUBOT_CYCLE_TZ_OFFSET or moment().zone()

# Basic variables
checkpoint = 5*60*60 # 5 hours per checkpoint
cycle = checkpoint * 35 # 35 checkpoints per cycle
seconds = 1000

getNextCycle = (next = 1) ->
    now = new Date().getTime()
    start = seconds * cycle * Math.floor now / (cycle * seconds)
    time = start + cycle * seconds * next
    moment(time).zone(tzOffset).format " #{timeFormat}"

getNextCheckpoint = (next = 1) ->
    now = new Date().getTime()
    start = checkpoint * seconds * Math.floor now / (checkpoint * seconds)
    time = start + checkpoint * seconds * next
    moment(time).zone(tzOffset).format " #{timeFormat}"

module.exports = (robot) ->
  robot.respond /cycle offset/i, (msg) ->
    msg.send "Current timezone offset is #{tzOffset} minutes."

  robot.respond /cycle set offset (.*)/i, (msg) ->
    tzOffset = msg.match[1]
    msg.send "Timezone offset is set to #{tzOffset}. I hope you know what you are doing."

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
