# This file is part of RC.
#
# RC is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with RC.  If not, see <https://www.gnu.org/licenses/>.

# смысл интерфейса, чтобы объявить публичные виртуальные методы (и/или) проперти
# сами они должны быть реализованы в тех классах, куда подмешаны интерфейсы
# !!! Вопрос: а надо ли указывать типы аргументов и возвращаемого значения в декларации методов в интерфейсе если эти методы виртуальные???????????
# !!! Ответ: т.к. это интерфейсы дефиниции методов должны быть полностью задекларированы, чтобы реализации строго соотвествовали сигнатурам методов интерфейса.
# если в интерфейсе объявлен тип выходного значения как AnyT то проверку можно сделать строже, объявив конкретный тип в реализации метода в самом классе.

module.exports = (Module)->
  {
    PRODUCTION
    CACHE
    # WEAK
    VIRTUAL
    Declare
    CoreObject
    Utils: {
      assign
      _
      t
      getTypeName
      createByType
      valueIsType
      isSubsetOf
      instanceOf
    }
  } = Module::

  { assert } = t

  # cache = new Set()

  class Interface extends CoreObject
    @inheritProtected()
    @module Module

    cpmDefineProperty = Symbol.for '~defineProperty'

    constructor: ->
      super()
      assert.fail 'new operator unsupported' if @ instanceof Interface

    @public @static new: Function,
      default: -> assert.fail 'new method unsupported for Interface'

    @public @static implements: Function,
      default: -> assert.fail 'implements method unsupported for Interface'

    @public @static include: Function,
      default: -> assert.fail 'include method unsupported for Interface'

    @public @static initializeMixin: Function,
      default: -> assert.fail 'initializeMixin method unsupported for Interface'

    @public @static virtual: Function,
      default: (args...)->
        assert args.length > 0, 'arguments is required'
        [typeDefinition] = args
        assert _.isPlainObject(typeDefinition), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to virtual(typeDefinition) (expected a plain object or @static or/and @async definition)"

        config = if typeDefinition.attr? and typeDefinition.attrType?
          typeDefinition
        else
          attr = Object.keys(typeDefinition)[0]
          attrType = typeDefinition[attr]
          attrType = @Module::AccordG attrType

          isFunction = attrType in [
            @Module::FunctionT
            @Module::GeneratorFunctionT
          ] or @Module::FunctorT.is attrType

          { attr, attrType, isFunction }

        config.level = VIRTUAL
        @[cpmDefineProperty] config

    @public @static initialize: Function,
      default: ->
        # NOTE: т.к. CoreObject.initialize будет проверять нереализованные виртуальные методы, здесь ни в коем случае нельзя вызывать @super
        @constructor = Module::Class
        assert _.isFunction(@Module.const), "Module of #{@name} must be subclass of RC::Module"
        if @Module isnt @ or @name is 'Module'
          if @Module::[@name]? and @Module::[@name].meta.kind is 'declare'
            @Module::[@name].define @
          else
            Reflect.defineProperty @, 'cache',
              configurable: no
              enumerable: yes
              writable: no
              value: new Set()

            # Reflect.defineProperty @, 'cacheStrategy',
            #   configurable: no
            #   enumerable: yes
            #   writable: no
            #   value: WEAK
            #
            # Reflect.defineProperty @, 'ID',
            #   configurable: no
            #   enumerable: yes
            #   writable: no
            #   value: @name
            @Module.const {
              "#{@name}": new Proxy @,
                apply: (target, thisArg, argumentsList)->
                  [value, path] = argumentsList
                  if Module.environment is PRODUCTION
                    return value
                  path ?= [target.name]
                  assert value?, "Invalid value #{assert.stringify value} supplied to #{path.join '.'}"
                  if target.cache.has value
                    return value
                  target.cache.add value
                  props = {}
                  instanceVirtualVariables = {}
                  instanceVirtualMethods = {}
                  for own k, {attrType} of target.instanceVirtualVariables
                    props[k] = attrType
                    instanceVirtualVariables[k] = attrType
                  for own k, {attrType} of target.instanceVirtualMethods
                    props[k] = attrType
                    instanceVirtualMethods[k] = attrType
                  if instanceOf(value, CoreObject) and value.constructor.isSupersetOf props
                    return value
                  for own k, attrType of instanceVirtualVariables
                    actual = value[k]
                    createByType attrType, actual, path.concat "#{k}: #{getTypeName attrType}"
                  for own k, attrType of instanceVirtualMethods
                    actual = value[k]
                    createByType attrType, actual, path.concat "#{k}: #{getTypeName attrType}"
                  return value
            }
            CACHE.set @Module::[@name], @name
        @

    @public @static displayName: String,
      get: -> @name

    @public @static is: Function,
      default: (x)->
        return no unless x?
        if @cache.has x
          return yes
        props = {}
        instanceVirtualVariables = {}
        instanceVirtualMethods = {}
        for own k, {attrType} of @instanceVirtualVariables
          props[k] = attrType
          instanceVirtualVariables[k] = attrType
        for own k, {attrType} of @instanceVirtualMethods
          props[k] = attrType
          instanceVirtualMethods[k] = attrType
        if instanceOf(x, CoreObject) and x.constructor.isSupersetOf props
          @cache.add x
          return yes
        for own k, attrType of instanceVirtualVariables
          return no unless valueIsType x[k], attrType
        for own k of instanceVirtualMethods
          return no unless _.isFunction x[k]
        @cache.add x
        return yes

    @public @static meta: Object,
      get: ->
        instanceVariables = {}
        instanceMethods = {}
        classVariables = {}
        classMethods = {}
        for own k, {attrType} of @instanceVirtualVariables
          instanceVariables[k] = attrType
        for own k, {attrType} of @instanceVirtualMethods
          instanceMethods[k] = attrType
        for own k, {attrType} of @classVirtualVariables
          classVariables[k] = attrType
        for own k, {attrType} of @classVirtualMethods
          classMethods[k] = attrType
        return {
          kind: 'interface'
          statics: assign {}, classVariables, classMethods
          props: assign {}, instanceVariables, instanceMethods
          name: @name
          identity: yes
          strict: no
        }


    @initialize()
