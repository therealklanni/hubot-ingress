chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
moment = require 'moment-timezone'

expect = chai.expect

describe 'ingress: cycle times', ->
  robot =
    respond: sinon.spy()
    hear: sinon.spy()

  beforeEach ->
    @robot = robot
    @msg =
      send: sinon.spy()
      reply: sinon.spy()
      envelope:
        user:
          @user
      message:
        user:
          @user

  process.env.HUBOT_CYCLE_TZ_NAME = 'UTC'
  require("../src/cycle-times")(robot)

  it 'registers "cycle" listener', ->
    expect(@robot.respond).to.have.been.calledWith /(septi)?cycle\s*([0-9])?$/i

  it 'registers "checkpoint" listener', ->
    expect(@robot.respond).to.have.been.calledWith /c(heck)?p(oint)?(\s+[0-9]+)?$/i

  it 'registers "checkpoints on day" listener', ->
    expect(@robot.respond).to.have.been.calledWith /c(heck)?p(oint)?s\s+on\s+((this|next)\s+)?([a-z]+day)/i

  it 'responds to "checkpoints on 12/25/13"', ->
    @msg.match = [0, 1, 2, '12/25/2013']
    @robot.respond.args[6][1](@msg)

    expect(@msg.send).to.have.been.calledWith sinon.match /^.*December 25th 2013.*4am, 9am, 2pm, 7pm, 12am\./i

  it 'responds to "checkpoints on Saturday"', ->
    @msg.match = [0, 1, 2, 3, 4, 'saturday']
    @robot.respond.args[5][1](@msg)
    today = moment().startOf 'day'
    saturday = moment().day('saturday').startOf 'day'
    saturday.add 7, "days" unless saturday.isAfter today
    realDate = saturday.format 'YYYY-MM-DD'
    otherMsg =
      send: sinon.spy()
      match: [0, 1, 2, realDate]

    @robot.respond.args[6][1](otherMsg)
    expect(@msg.send).to.have.been.calledWith otherMsg.send.args[0][0]

  it 'registers "checkpoints on date" listener', ->
    expect(@robot.respond).to.have.been.calledWith /c(heck)?p(oint)?s on (.*)/i

  it 'registers "cycle offset" listener', ->
    expect(@robot.respond).to.have.been.calledWith /cycle offset/i

  it 'registers "cycle set offset" listener', ->
    expect(@robot.respond).to.have.been.calledWith /cycle set offset (.*)/i

  it 'registers "cycle set offsetname" listener', ->
    expect(@robot.respond).to.have.been.calledWith /cycle set offsetname (.*)/i

  it 'registers "mu" listener', ->
    expect(@robot.respond).to.have.been.calledWith /m(ind\s*)?u(nits?)?( needed)?\s+([0-9]+k?)\s+([0-9]+k?)/i

  it 'registers "average mu" listener', ->
    expect(@robot.respond).to.have.been.calledWith /m(ind\s*)?u(nits?)? average\s+([0-9]+k?)\s+([0-9]+k?)/i
