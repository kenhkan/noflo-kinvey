noflo = require 'noflo'
Kinvey = require 'kinvey'

class DataStoreFind extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'

exports.getComponent = -> new DataStoreFind
