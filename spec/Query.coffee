noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Query = require '../components/Query.coffee'
else
  Query = require 'noflo-kinvey/components/Query.js'

Kinvey = require 'kinvey'

describe 'Query component', ->
  globals = {}

  beforeEach ->
    globals.c = Query.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.kinvey = noflo.internalSocket.createSocket()
    globals.options = noflo.internalSocket.createSocket()
    globals.equalTo = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.inPorts.kinvey.attach globals.kinvey
    globals.c.inPorts.options.attach globals.options
    globals.c.inPorts.equalTo.attach globals.equalTo
    globals.c.outPorts.out.attach globals.out

  describe 'when intantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
      chai.expect(globals.c.inPorts.kinvey).to.be.an 'object'
      chai.expect(globals.c.inPorts.options).to.be.an 'object'
      chai.expect(globals.c.inPorts.equalTo).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'

  describe 'when querying', ->
    it 'by equality', (done) ->
      kinvey = new Kinvey

      globals.out.on 'data', (query) ->
        chai.expect(query).to.be.instanceof kinvey.Query
        done()

      globals.kinvey.send kinvey
      globals.kinvey.disconnect()

      globals.equalTo.send ['_id', 'id']
      globals.equalTo.send ['name', 'Ken']
      globals.equalTo.disconnect()

      globals.in.send 'query'
      globals.in.disconnect()
