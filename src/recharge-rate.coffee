# Description:
#   Calculate Recharge Rate in Ingress.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot recharge distance|max [level]
#   hubot recharge rate|efficiency|percent [level] [distance]
#
# Author:
#   impleri

precision = 10 # each zero = 1 decimal place

calculateEfficiency = (distance, level = 8) ->
    efficiency = 100 - (distance / (5 * level))
    efficiency = 0 if efficiency < 50
    round efficiency

calculateDistance = (level = 8) ->
    250 * level

convertToKm = (distance, unit = "km") ->
    switch unit
        when "m", "meters" then divisor = 1000
        when "ft", "foot", "feet" then divisor = 3280.84
        when "yd", "yard", "yards" then divisor = 1093.61
        when "mi", "miles" then divisor = 0.621371
        else divisor = 1
    distance/divisor

round = (number) ->
    Math.round(number*precision)/precision

module.exports = (robot) ->
  robot.respond /recharge\s+(max|distance)\s+([0-9]{1,2})/i, (msg) ->
    level = +msg.match[2]
    distance = calculateDistance level
    msg.send "A level #{level} agent can recharge up to #{distance} km away."

  robot.respond /recharge\s+(efficiency|rate|percent)\s+([0-9]{1,2})\s+([0-9\.]+)\s*([a-z]+)?/i, (msg) ->
    level = +msg.match[2]
    qty = +msg.match[3]
    distance = round convertToKm qty, msg.match[4]
    rate = calculateEfficiency distance, level
    response = "A level #{level} agent cannot recharge from #{distance} km away."
    response = "A level #{level} agent can recharge from #{distance} km away at #{rate}%." if rate > 0
    msg.send response
