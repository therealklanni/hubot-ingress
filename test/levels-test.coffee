chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'ingress: levels', ->
  robot =
    respond: sinon.spy()

  beforeEach ->
    @robot = robot
    @msg =
      reply: sinon.spy()

  require('../src/levels')(robot)

  it 'registers AP per level listener', ->
    expect(@robot.respond).to.have.been.calledWith(/AP\s+(?:to|(?:un)?til)\s+L?(\d\d?)/i)

  it 'registers AP for all levels listener', ->
    expect(@robot.respond).to.have.been.calledWith(/AP all/i)

  it 'responds to AP query', ->
    @msg.match = [null, 3]
    @robot.respond.args[0][1](@msg)
    expect(@msg.reply).to.have.been.calledWithMatch(/A total of \d+ AP.*? is needed to reach L\d\d?/)
