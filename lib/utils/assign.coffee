_       = require 'lodash'

customizer = (objValue, srcValue)->
  if _.isArray objValue
    objValue.concat srcValue

module.exports = ->
  target = _.head arguments
  if _.isArray target
    others = _.tail arguments
    _.concat target, others...
  else
    args = _.slice arguments
    args.push customizer
    _.mergeWith args...
  
