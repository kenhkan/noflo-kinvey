noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  DataStoreFind = require '../components/DataStoreFind.coffee'
else
  DataStoreFind = require 'noflo-kinvey/components/DataStoreFind.js'

Kinvey = require 'kinvey'

describe 'DataStoreFind component', ->
  globals = {}

  beforeEach ->
    globals.c = DataStoreFind.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.collection = noflo.internalSocket.createSocket()
    globals.kinvey = noflo.internalSocket.createSocket()
    globals.options = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.error = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.inPorts.collection.attach globals.collection
    globals.c.inPorts.kinvey.attach globals.kinvey
    globals.c.inPorts.options.attach globals.options
    globals.c.outPorts.out.attach globals.out
    globals.c.outPorts.error.attach globals.error

  describe 'when intantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
      chai.expect(globals.c.inPorts.collection).to.be.an 'object'
      chai.expect(globals.c.inPorts.kinvey).to.be.an 'object'
      chai.expect(globals.c.inPorts.options).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
      chai.expect(globals.c.outPorts.error).to.be.an 'object'

  describe 'prerequisites', ->
    it 'does not proceed without a collection', (done) ->
      globals.error.on 'data', (e) ->
        chai.expect(e).to.be.instanceof Error
        chai.expect(e.message).to.equal 'No collection name provided'
        done()

      globals.kinvey.send new Kinvey
      globals.kinvey.disconnect()

      globals.in.send new Kinvey.Query
      globals.in.disconnect()

    it 'does not proceed without a Kinvey object', (done) ->
      globals.error.on 'data', (e) ->
        chai.expect(e).to.be.instanceof Error
        chai.expect(e.message).to.equal 'No Kinvey instance provided'
        done()

      globals.collection.send 'users'
      globals.collection.disconnect()

      globals.in.send new Kinvey.Query
      globals.in.disconnect()

    it 'does not proceed with a non-Query object', (done) ->
      globals.error.on 'data', (e) ->
        chai.expect(e).to.be.instanceof Error
        chai.expect(e.message).to.equal 'Not a Kinvey.Query object'
        done()

      globals.kinvey.send new Kinvey
      globals.kinvey.disconnect()

      globals.collection.send 'users'
      globals.collection.disconnect()

      globals.in.send 'not a query object'
      globals.in.disconnect()

  describe 'finding the way', ->
    it 'finds nothing without an account', (done) ->
      kinvey = new Kinvey

      globals.out.on 'data', (promise) ->
        promise.then (doc) ->
          chai.expect(false).to.be.true
        , (error) ->
          chai.expect(true).to.be.true
          done()

      globals.kinvey.send kinvey
      globals.kinvey.disconnect()

      globals.collection.send 'users'
      globals.collection.disconnect()

      globals.in.send new kinvey.Query
      globals.in.disconnect()
