

module.exports = (Module)->
  {
    SubtypeG
    TypeT
  } = Module::

  Module.defineType SubtypeG TypeT, 'FunctorT', (x)->
    x.meta.kind in ['func', 'async']