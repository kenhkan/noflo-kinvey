noflo = require 'noflo'
Kinvey = require 'kinvey'

class UserLogin extends noflo.Component
  constructor: ->
    @inPorts =
      user: new noflo.Port 'any'
      kinvey: new noflo.Port 'object'
      password: new noflo.Port 'string'
      options: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.kinvey.on 'data', (@kinvey) => @login()
    @inPorts.options.on 'data', (@options) =>
    @inPorts.password.on 'data', (@password) => @login()
    @inPorts.user.on 'data', (@user) => @login()

  login: ->
    return unless @user? and @password? and @kinvey?

    # Apply the query and forward
    promise = @kinvey.User.login @user, @password, @options
    @outPorts.out.send promise
    @outPorts.out.disconnect()

exports.getComponent = -> new UserLogin
