noflo = require 'noflo'
Kinvey = require 'kinvey'

class QueryEqualTo extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
      field: new noflo.Port 'string'
      value: new noflo.Port 'any'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.field.on 'data', (@field) =>
    @inPorts.value.on 'data', (@value) =>

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'endgroup', (group) =>
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

    @inPorts.in.on 'data', (query) =>
      # Only apply if applicable
      if @field? and @value?
        query.equalTo @field, @value

      # Always forward though
      @outPorts.out.send query

exports.getComponent = -> new QueryEqualTo
