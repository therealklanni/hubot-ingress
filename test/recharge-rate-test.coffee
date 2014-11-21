chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'ingress: recharge', ->
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

  require("../src/recharge-rate")(robot)

  it 'registers "recharge distance" listener', ->
    expect(@robot.respond).to.have.been.calledWith /recharge\s+(max|distance)\s+([0-9]{1,2})/i

  it 'registers "recharge rate" listener', ->
    expect(@robot.respond).to.have.been.calledWith /recharge\s+(efficiency|rate|percent)\s+([0-9]{1,2})\s+([0-9\.]+)\s*([a-z]+)?/i

  it 'responds to "recharge distance"', ->
    @msg.match = [0, 'max', '8']
    @robot.respond.args[0][1](@msg)
    expect(@msg.send).to.have.been.calledWith('A level 8 agent can recharge up to 2000 km away.')

  it 'responds to potential "recharge rate"', ->
    @msg.match = [0, 'rate', '8', '1000']
    @robot.respond.args[1][1](@msg)
    expect(@msg.send).to.have.been.calledWith('A level 8 agent can recharge from 1000 km away at 75%.')

  it 'responds to out-of-range "recharge rate"', ->
    @msg.match = [0, 'rate', '8', '3000']
    @robot.respond.args[1][1](@msg)
    expect(@msg.send).to.have.been.calledWith('A level 8 agent cannot recharge from 3000 km away.')
