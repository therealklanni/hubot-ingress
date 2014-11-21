chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'ingress: levels', ->
  robot =
    respond: sinon.spy()

  beforeEach ->
    @robot = robot

  require('../src/levels')(robot)

  it 'registers AP per level listener', ->
    expect(@robot.respond).to.have.been.calledWith(/AP\s+(?:to|(?:un)?til)\s+L?(\d{1,2})/i)

  it 'registers AP for all levels listener', ->
    expect(@robot.respond).to.have.been.calledWith(/AP all/i)
