chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'ingress', ->
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
    body: '{"results": [{ "geometry": { "location": { "lat": "LatNoKey", "lng": "LongNoKey" } } }]}'
    lat: "LatNoKey"
    long: "LongNoKey"
  httpResponseKey = 
    expectedKey: 'ExpectedGeocodeKey'
    body: '{"results": [{ "geometry": { "location": { "lat": "LatKey", "lng": "LongKey" } } }]}'
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
                

  require('../src/ingress')(robot)
  require("../src/recharge-rate")(robot)

  describe 'respond listener', ->

    it 'registers AP per level listener', ->
      expect(@robot.respond).to.have.been.calledWith(/AP\s+(?:to|(?:un)?til)\s+L?(\d{1,2})/i)

    it 'registers AP for all levels listener', ->
      expect(@robot.respond).to.have.been.calledWith(/AP all/i)

    describe 'badges commands', ->
      it 'registers "have badge" listener', ->
        expect(@robot.respond).to.have.been.calledWith(/(I|@?\w+) (?:have|has|got|earned)(?: the)? :?([\w,\s]+):? badges?/i)

      it 'registers "what badges" listener', ->
        expect(@robot.respond).to.have.been.calledWith(/wh(?:at|ich) badges? do(?:es)? (I|@?\w+) have/i)

      it 'registers "do not have" listener', ->
        expect(@robot.respond).to.have.been.calledWith(/(I|@?\w+) (?:do(?:n't|esn't| not)) have the :?(\w+):? badge/i)

      it 'responds to "I have the founder badge"', ->
        @msg.match = [0, 'I', 'founder']
        @robot.respond.args[2][1](@msg)
        badges = @data.ingressBadges.U123
        expect(@msg.reply).to.have.been.calledWith('congrats on earning the :founder: badge!')
        expect(badges).to.be.a('array')
        expect(badges).to.include(':founder:')

      it 'responds with error message on invalid badge name', ->
        @msg.match = [0, 'I', 'random']
        @robot.respond.args[2][1](@msg)
        badges = @data.ingressBadges.U123
        expect(@msg.reply).to.have.been.calledWith('invalid badge name(s): random.')
        expect(badges).to.be.a('array')
        expect(badges).not.to.include(':random:')

      it '"I have" automatically replaces badge of same type', ->
        @msg.match = [0, 'I', 'hacker1']
        @robot.respond.args[2][1](@msg)
        badges = @data.ingressBadges.U123
        expect(@msg.reply).to.have.been.calledWith('congrats on earning the :hacker1: badge!')
        expect(badges).to.be.a('array')
        expect(badges).to.include(':hacker1:')
        @msg.match = [0, 'I', 'hacker2']
        @robot.respond.args[2][1](@msg)
        badges = @data.ingressBadges.U123
        expect(@msg.reply).to.have.been.calledWith('congrats on earning the :hacker2: badge!')
        expect(badges).to.be.a('array')
        expect(badges).not.to.include(':hacker1:')
        expect(badges).to.include(':hacker2:')

      it '"I have" can handle multiple badge names', ->
        @msg.match = [0, 'I', 'pioneer3, hacker4, builder1']
        @robot.respond.args[2][1](@msg)
        badges = @data.ingressBadges.U123
        expect(@msg.reply).to.have.been.calledWith(sinon.match(/congrats on earning the .* badges!/))
        expect(badges).to.be.a('array')
        expect(badges).to.include(':pioneer3:')
        expect(badges).to.include(':hacker4:')
        expect(badges).to.include(':builder1:')

      it 'responds to "sinon2 has the verified badge"', ->
        @msg.match = [0, 'sinon2', 'verified']
        @robot.respond.args[2][1](@msg)
        badges = @data.ingressBadges.U234
        expect(@msg.send).to.have.been.calledWith('@sinon2: congrats on earning the :verified: badge!')
        expect(badges).to.be.a('array')
        expect(badges).to.include(':verified:')

      it 'responds to "what badges do I have"', ->
        @msg.match = [0, 'I']
        @robot.respond.args[3][1](@msg)
        expect(@msg.reply).to.have.been.calledWith(sinon.match(/You have (the following|no) badges.*/))

      it 'responds to "what badges does sinon2 have"', ->
        @msg.match = [0, 'sinon2']
        @robot.respond.args[3][1](@msg)
        expect(@msg.reply).to.have.been.calledWith(sinon.match(/sinon2 has (the following|no) badges.*/))

      it 'responds to "I don\'t have the founder badge"', ->
        @msg.match = [0, 'I', 'founder']
        @robot.respond.args[4][1](@msg)
        badges = @data.ingressBadges.U123
        expect(@msg.reply).to.have.been.calledWith('removed the :founder: badge')
        expect(badges).not.to.include(':founder:')

    describe 'intelmap listener', ->

      it 'responds to intelmap when http request results in error', ->
        @msg.match = [0, 'intelmap', httpError.location]
        @robot.respond.args[6][1](@msg)
        expect(@msg.send).to.have.been.calledWith(httpError.expected)

      it 'responds to intelmap with not found when there is a different error', ->
        @msg.match = [0, 'intelmap', parseError.location]
        @robot.respond.args[6][1](@msg)
        expect(@msg.send).to.have.been.calledWith("Could not find #{parseError.location}")

      it 'responds to intelmap with url when no Google Geocode API key set', ->
        @msg.match = [0, 'intelmap', 'boston ma']
        @robot.respond.args[6][1](@msg)
        expect(@msg.reply).to.have.been.calledWith("https://www.ingress.com/intel?ll=#{httpResponseNoKey.lat},#{httpResponseNoKey.long}&z=16")

      it 'responds to intelmap with url when Google Geocode API key set', ->
        @msg.match = [0, 'intelmap', 'boston ma']
        @robot.googleGeocodeKey = httpResponseKey.expectedKey
        @robot.respond.args[6][1](@msg)
        expect(@msg.reply).to.have.been.calledWith("https://www.ingress.com/intel?ll=#{httpResponseKey.lat},#{httpResponseKey.long}&z=16")

    describe 'recharge distance listener',->

      it 'registers "recharge distance" listener', ->
        expect(@robot.respond).to.have.been.calledWith /recharge\s+(max|distance)\s+([0-9]{1,2})/i

      it 'registers "recharge rate" listener', ->
        expect(@robot.respond).to.have.been.calledWith /recharge\s+(efficiency|rate|percent)\s+([0-9]{1,2})\s+([0-9\.]+)\s*([a-z]+)?/i

      it 'responds to "recharge distance"', ->
        @msg.match = [0, 'max', '8']
        @robot.respond.args[7][1](@msg)
        expect(@msg.reply).to.have.been.calledWith('A level 8 agent can recharge up to 2000 km away.')

      it 'responds to potential "recharge rate"', ->
        @msg.match = [0, 'rate', '8', '1000']
        @robot.respond.args[8][1](@msg)
        expect(@msg.reply).to.have.been.calledWith('A level 8 agent can recharge from 1000 km away at 75%.')

      it 'responds to out-of-range "recharge rate"', ->
        @msg.match = [0, 'rate', '8', '3000']
        @robot.respond.args[8][1](@msg)
        expect(@msg.reply).to.have.been.calledWith('A level 8 agent cannot recharge from 3000 km away.')
