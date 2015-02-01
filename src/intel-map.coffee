# Description
#   Ingress helper commands for Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GOOGLE_GEOCODE_KEY (optional, may be needed if no results are returned)
#
# Commands:
#   hubot intelmap for <search>
#
# Author:
#   therealklanni

module.exports = (robot) ->
  # Setting this on robot so that it can be overridden in test. Is there a better way?
  robot.googleGeocodeKey = process.env.HUBOT_GOOGLE_GEOCODE_KEY
  googleGeocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json'

  lookupLatLong = (msg, location, cb) ->
    params =
      address: location
    params.key = robot.googleGeocodeKey if robot.googleGeocodeKey?

    msg.http(googleGeocodeUrl).query(params)
      .get() (err, res, body) ->
        try
          body = JSON.parse body
          coords = body.results[0].geometry.location
        catch err
          err = "Could not find #{location}"
          return cb(err, msg, null)
        cb(err, msg, coords)

  intelmapUrl = (coords) ->
    return "https://www.ingress.com/intel?ll=" + encodeURIComponent(coords.lat) + "," + encodeURIComponent(coords.lng) + "&z=16"
  sendIntelLink = (err, msg, coords) ->
    return msg.send err if err
    url = intelmapUrl coords
    msg.reply url

  robot.respond /(intelmap|intel map)(?: for)?\s(.*)/i, (msg) ->
    location = msg.match[2]
    lookupLatLong msg, location, sendIntelLink
