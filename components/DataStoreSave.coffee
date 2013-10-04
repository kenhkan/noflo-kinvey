noflo = require 'noflo'
Kinvey = require 'kinvey'

class DataStoreSave extends noflo.Component
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

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'endgroup', (group) =>
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

    @inPorts.in.on 'data', (doc) =>
      # Handle missing values
      unless @collection?
        @outPorts.error.send new Error 'No collection name provided'
        @outPorts.error.disconnect()
        return
      unless @kinvey?
        @outPorts.error.send new Error 'No Kinvey instance provided'
        @outPorts.error.disconnect()
        return
      unless typeof doc is 'object'
        @outPorts.error.send new Error 'Not an object'
        @outPorts.error.disconnect()
        return

      # Apply the query and forward
      promise = @kinvey.DataStore.save @collection, doc, @options
      @outPorts.out.send promise

exports.getComponent = -> new DataStoreSave
