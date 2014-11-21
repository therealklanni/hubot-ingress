chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

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

  require("../src/cycle-times")(robot)

  it 'registers "cycle" listener', ->
    expect(@robot.respond).to.have.been.calledWith /(septi)?cycle\s*([0-9])?/i

  it 'registers "checkpoint" listener', ->
    expect(@robot.respond).to.have.been.calledWith /c(heck)?p(oint)?\s*([0-9])?/i

  it 'registers "cycle offset" listener', ->
    expect(@robot.respond).to.have.been.calledWith /cycle offset/i

  it 'registers "cycle set offset" listener', ->
    expect(@robot.respond).to.have.been.calledWith /cycle set offset (.*)/i

  it 'registers "cycle set offsetname" listener', ->
    expect(@robot.respond).to.have.been.calledWith /cycle set offsetname (.*)/i
