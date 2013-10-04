noflo = require 'noflo'
Kinvey = require 'kinvey'

class CreateQuery extends noflo.Component
  constructor: ->
    @groupStacks = []
    # Single variable to contain all the parameters to set on the query
    @params = {}

    @inPorts =
      in: new noflo.Port 'bang'
      kinvey: new noflo.Port 'object'
      options: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'object'

    @inPorts.options.on 'data', (@options) =>
    @inPorts.kinvey.on 'data', (@kinvey) =>
      @create()
    @inPorts.in.on 'data', (@data) => @create()

    # Save groups
    @inPorts.in.on 'connect', =>
      @groups = []
    @inPorts.in.on 'begingroup', (group) =>
      @groups.push group
    @inPorts.in.on 'disconnect', =>
      @groupStacks.push @groups if @groups?

  create: ->
    return unless @kinvey? and @data?

    # Create the query
    createQuery = => new @kinvey.Query @options

    # Forward it to each set of groups
    for groupStack in @groupStacks
      @outPorts.out.beginGroup group for group in groupStack
      @outPorts.out.send createQuery()
      @outPorts.out.endGroup() for group in groupStack
      @outPorts.out.disconnect()

    # To groups in current execution too
    @outPorts.out.beginGroup group for group in @groups
    @outPorts.out.send createQuery()
    @outPorts.out.endGroup() for group in @groups
    @outPorts.out.disconnect()

    # Clean up
    @groupStacks = []
    delete @groups
    delete @data

exports.getComponent = -> new CreateQuery
