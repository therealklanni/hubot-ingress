chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'ingress: intelmap', ->
  user =
    name: 'sinon'
    id: 'U123'
  robot =
    respond: sinon.spy()
    hear: sinon.spy()
    brain:
      on: (_, cb) ->
        cb()
      data: {}
      userForName: (who) ->
        forName =
          name: who
          id: 'U234'
  httpError =
    location: "http_error"
    expected: "this error is used"
  parseError =
    location: "parse_error"
  httpResponseNoKey =
    body: '{"results": [{ "formatted_address" : "Some, Formatted, Address", "geometry": { "location": { "lat": "LatNoKey", "lng": "LongNoKey" } } }]}'
    formatted_address: "Some, Formatted, Address"
    lat: "LatNoKey"
    long: "LongNoKey"
  httpResponseKey =
    expectedKey: 'ExpectedGeocodeKey'
    body: '{"results": [{ "formatted_address" : "Some, Formatted, Address", "geometry": { "location": { "lat": "LatKey", "lng": "LongKey" } } }]}'
    formatted_address: "Some, Formatted, Address"
    lat: "LatKey"
    long: "LongKey"

  beforeEach ->
    @user = user
    @robot = robot
    @data = @robot.brain.data
    @msg =
      send: sinon.spy()
      reply: sinon.spy()
      envelope:
        user:
          @user
      message:
        user:
          @user
      http: (url) ->
        query: (params) ->
          get: () -> (cb) ->
            return switch params.address
              when httpError.location
                cb(httpError.expected, null, httpResponseNoKey.body)
              when parseError.location
                cb("this is ignored", null, '{ blahblah }')
              else
                if params.key == httpResponseKey.expectedKey
                  cb(null, null, httpResponseKey.body)
                else
                  cb(null, null, httpResponseNoKey.body)
    @robot.googleGeocodeKey = undefined


  require('../src/intel-map')(robot)

  it 'responds to intelmap when http request results in error', ->
    @msg.match = [0, 'intelmap', httpError.location]
    @robot.respond.args[0][1](@msg)
    expect(@msg.send).to.have.been.calledWith(httpError.expected)

  it 'responds to intelmap with not found when there is a different error', ->
    @msg.match = [0, 'intelmap', parseError.location]
    @robot.respond.args[0][1](@msg)
    expect(@msg.send).to.have.been.calledWith("Could not find #{parseError.location}")

  it 'responds to intelmap with url when no Google Geocode API key set', ->
    @msg.match = [0, 'intelmap', 'boston ma']
    @robot.respond.args[0][1](@msg)
    expect(@msg.send).to.have.been.calledWith("#{httpResponseKey.formatted_address}\nhttps://www.ingress.com/intel?ll=#{httpResponseNoKey.lat},#{httpResponseNoKey.long}&z=16")

  it 'responds to intelmap with url when Google Geocode API key set', ->
    @msg.match = [0, 'intelmap', 'boston ma']
    @robot.googleGeocodeKey = httpResponseKey.expectedKey
    @robot.respond.args[0][1](@msg)
    expect(@msg.send).to.have.been.calledWith("#{httpResponseKey.formatted_address}\nhttps://www.ingress.com/intel?ll=#{httpResponseKey.lat},#{httpResponseKey.long}&z=16")
