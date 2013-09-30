noflo = require 'noflo'
Kinvey = require 'kinvey'
_ = require 'lodash'

paramNames = 'equalTo'.split ' '

class Query extends noflo.Component
  constructor: ->
    # Single variable to contain all the parameters to set on the query
    @params = {}

    @inPorts =
      in: new noflo.Port 'object'
      kinvey: new noflo.Port 'object'
      options: new noflo.Port 'object'
      equalTo: new noflo.Port 'array'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'object'

    @inPorts.options.on 'data', (@options) =>
    @inPorts.kinvey.on 'data', (@kinvey) =>

    @inPorts.equalTo.on 'connect', =>
      @params.equalTo = []
    @inPorts.equalTo.on 'data', (params) =>
      @params.equalTo.push params

    @inPorts.in.on 'data', (data) =>
      # Handle missing values
      unless @kinvey?
        @outPorts.error.send new Error 'No Kinvey instance provided'
        @outPorts.error.disconnect()
        return

      # Create the query
      query = new @kinvey.Query @options

      # Set parameters
      @setParams query

      # Forward it
      @outPorts.out.send query
      @outPorts.out.disconnect()

  setParams: (query) ->
    for paramName in paramNames
      params = @params[paramName]

      # Make sure the param is an array before continuing
      if _.isArray params
        # Each item is the arguments to pass to query
        for param in params
          if _.isArray param
            query[paramName].apply query, param

exports.getComponent = -> new Query
