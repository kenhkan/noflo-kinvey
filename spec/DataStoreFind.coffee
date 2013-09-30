noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  DataStoreFind = require '../components/DataStoreFind.coffee'
else
  DataStoreFind = require 'noflo-kinvey/components/DataStoreFind.js'

describe 'DataStoreFind component', ->
  globals = {}

  beforeEach ->
    globals.c = DataStoreFind.getComponent()
    globals.ins = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.ins
    globals.c.outPorts.out.attach globals.out

  describe 'when instantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
