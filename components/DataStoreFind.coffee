noflo = require 'noflo'
Kinvey = require 'kinvey'

class DataStoreFind extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
      collection: new noflo.Port 'string'
      kinvey: new noflo.Port 'object'
      options: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'object'

    @inPorts.collection.on 'data', (@collection) =>
    @inPorts.kinvey.on 'data', (@kinvey) =>
    @inPorts.options.on 'data', (@options) =>

    @inPorts.in.on 'data', (query) =>
      # Handle missing values
      unless @collection?
        @outPorts.error.send new Error 'No collection name provided'
        @outPorts.error.disconnect()
        return
      unless @kinvey?
        @outPorts.error.send new Error 'No Kinvey instance provided'
        @outPorts.error.disconnect()
        return
      unless query instanceof @kinvey.Query
        @outPorts.error.send new Error 'Not a Kinvey.Query object'
        @outPorts.error.disconnect()
        return

      # Apply the query and forward
      promise = @kinvey.DataStore.find @collection, query, @options
      @outPorts.out.send promise
      @outPorts.out.disconnect()

exports.getComponent = -> new DataStoreFind
