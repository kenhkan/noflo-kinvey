noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  KinveyComponent = require '../components/Kinvey.coffee'
else
  KinveyComponent = require 'noflo-kinvey/components/Kinvey.js'

Kinvey = require 'kinvey'

describe 'Kinvey component', ->
  globals = {}

  beforeEach ->
    globals.c = KinveyComponent.getComponent()
    globals.key = noflo.internalSocket.createSocket()
    globals.secret = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.c.inPorts.key.attach globals.key
    globals.c.inPorts.secret.attach globals.secret
    globals.c.outPorts.out.attach globals.out

  describe 'when instantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.key).to.be.an 'object'
      chai.expect(globals.c.inPorts.secret).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'

  describe 'creating instances', ->
    it 'creates a Kinvey instance given key and secret', (done) ->
      globals.out.on 'data', (kinvey) ->
        chai.expect(kinvey.API_ENDPOINT).to.equal 'https://baas.kinvey.com'
        done()

      globals.key.send 'key'
      globals.secret.send 'secret'
