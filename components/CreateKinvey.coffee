noflo = require 'noflo'
Kinvey = require 'kinvey'

class CreateKinvey extends noflo.Component
  constructor: ->
    @inPorts =
      key: new noflo.Port 'string'
      secret: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.key.on 'data', (@key) => @instantiate()
    @inPorts.secret.on 'data', (@secret) => @instantiate()

  instantiate: ->
    return unless @key? and @secret?

    # Create a copy
    kinvey = Kinvey()
    promise = kinvey.init
      appKey: @key
      appSecret: @secret

    # Return the Kinvey instance instead
    promise = promise.then (value) -> kinvey

    # Send the promise along
    @outPorts.out.send promise
    @outPorts.out.disconnect()

exports.getComponent = -> new CreateKinvey
