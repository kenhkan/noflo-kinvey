noflo = require 'noflo'
Kinvey = require 'kinvey'

class KinveyComponent extends noflo.Component
  constructor: ->
    @inPorts =
      key: new noflo.Port 'string'
      secret: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.key.on 'data', (@key) =>
      @instantiate()
    @inPorts.secret.on 'data', (@secret) =>
      @instantiate()

  instantiate: ->
    return unless @key? and @secret?

    # Create a copy
    kinvey = Kinvey()
    kinvey.init
      appKey: @key
      appSecret: @secret

    # Send it along
    @outPorts.out.send kinvey
    @outPorts.out.disconnect()

    # Clean up
    delete @key
    delete @secret

exports.getComponent = -> new KinveyComponent
