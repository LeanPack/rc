
###
Пример инклуда для CoffeeScript 2.x
class CoreObject
  size: ->
    8
  @include: (aMixin)->
    SuperClass = Object.getPrototypeOf @
    vMixin = aMixin SuperClass
    Object.setPrototypeOf @, vMixin
    Object.setPrototypeOf @::, vMixin::
    return

_ControllerMixin = (Base)->
  class ControllerMixin extends Base
    size: ->
      super() + 4
    @size: ->
      66

_Controller1Mixin = (Base)->
  class Controller1Mixin extends Base
    size: ->
      super() + 1

class CucumberController extends CoreObject
  @include _ControllerMixin
  @include _Controller1Mixin

cu = new CucumberController()
console.log cu.size()
console.log CucumberController.size()
console.log CucumberController, cu
###


###
RC = require 'RC'
{AnyT} = RC::


module.exports = (App)->
  class App::TestInterface extends RC::Interface
    @inheritProtected()

    @Module: App

    # only public virtual properties and methods
    @public @static @virtual new: Function,
      args: [String, Object]
      return: Object
    @public @static @virtual create: Function,
      args: AnyT
      return: AnyT
    @public @virtual testing: Function,
      args: [Object, RC::Class, Boolean, String, Function]
      return: AnyT
  App::TestInterface.initialize()
###

###
RC = require 'RC'


module.exports = (App)->
  class App::TestMixin extends RC::Mixin
    @inheritProtected()

    @Module: App

    @public methodInMixin: Function,
      args: [String, Object]
      return: Object
      default: (asPath, ahConfig)-> #some code

  App::TestMixin.initialize()
###

###
RC = require 'RC'

module.exports = (App)->
  class App::Test extends RC::CoreObject
    @inheritProtected()
    @implements App::TestInterface
    @include App::TestMixin

    @Module: App

    ipnTestIt = @private testIt: Number,
      default: 9
      get: (anValue)-> anValue
      set: (anValue)->
        @send 'testItChanged', anValue
        anValue + 98

    ipcModel = @protected Model: RC::Class,
      default: Basis::User

    @public @static new: Function,
      default: (args...)->
        @super args...
        #some code
    @public @static create: Function,
      default: (args...)-> @::[ipcModel].new args...

    @public testing: Function,
      default: (ahConfig, alUsers, isInternal, asPath, lambda)->
        vhResult = @methodInMixin path, config
        #some code
  App::Test.initialize()
###


module.exports = (RC)->
  {
    PRODUCTION
    VIRTUAL, STATIC, ASYNC, CONST
    PUBLIC, PRIVATE, PROTECTED
  } = RC::

  _ = RC::_ ? RC::Utils._
  t = RC::t ? RC::Utils.t
  { assert } = t

  class RC::CoreObject
    CLASS_KEYS = [
      'arguments', 'name', 'displayName', 'caller', 'length', 'prototype'
      'constructor', '__super__', 'including'
    ]
    INSTANCE_KEYS = [
      'constructor', '__proto__'
      # 'length',
      'arguments', 'caller'
    ]
    cpmDefineProperty             = Symbol.for '~defineProperty'
    cplExtensibles                = Symbol.for '~isExtensible'
    cpsExtensibleSymbol           = Symbol.for '~extensibleSymbol'

    cpoMetaObject                 = Symbol.for '~metaObject'

    Reflect.defineProperty @, cpoMetaObject,
      enumerable: no
      configurable: yes
      value: new RC::MetaObject @

    Reflect.defineProperty @, cplExtensibles,
      enumerable: no
      configurable: no
      value: {}

    Reflect.defineProperty @, cpsExtensibleSymbol,
      enumerable: no
      configurable: yes
      value: Symbol 'extensibleSymbol'

    Reflect.defineProperty @, 'isExtensible',
      enumerable: yes
      configurable: no
      get: -> @[cplExtensibles][@[cpsExtensibleSymbol]]

    constructor: (args...) ->
      @init args...

    # Core class API
    Reflect.defineProperty @, 'super',
      enumerable: yes
      value: ->
        {caller} = arguments.callee
        vClass = caller.class ? @
        SuperClass = Reflect.getPrototypeOf vClass
        methodName = caller.pointer ? caller.name
        method = SuperClass?[methodName]
        method?.apply @, arguments

    Reflect.defineProperty @::, 'super',
      enumerable: yes
      value: ->
        {caller} = arguments.callee
        vClass = caller.class ? @constructor
        SuperClass = Reflect.getPrototypeOf vClass
        methodName = caller.pointer ? caller.name
        method = SuperClass::?[methodName]
        method?.apply @, arguments

    Reflect.defineProperty @, 'wrap',
      enumerable: yes
      value: (lambda)->
        {caller} = arguments.callee
        vcClass = caller.class ? @
        vsName = caller.name
        vsPointer = caller.pointer
        wrapper = (args...)=> lambda.apply @, args
        Reflect.defineProperty wrapper, 'class',
          value: vcClass
          enumerable: yes
        Reflect.defineProperty lambda, 'class',
          value: vcClass
          enumerable: yes
        Reflect.defineProperty wrapper, 'name',
          value: vsName
          configurable: yes
        Reflect.defineProperty lambda, 'name',
          value: vsName
          configurable: yes
        Reflect.defineProperty wrapper, 'pointer',
          value: vsPointer
          configurable: yes
          enumerable: yes
        Reflect.defineProperty lambda, 'pointer',
          value: vsPointer
          configurable: yes
          enumerable: yes
        Reflect.defineProperty lambda, 'wrapper',
          value: wrapper
          enumerable: yes
        Reflect.defineProperty wrapper, 'body',
          value: lambda
          enumerable: yes

        wrapper

    Reflect.defineProperty @::, 'wrap',
      enumerable: yes
      value: (lambda)->
        {caller} = arguments.callee
        vcClass = caller.class ? @constructor
        vsName = caller.name
        vsPointer = caller.pointer
        wrapper = (args...)=> lambda.apply @, args
        Reflect.defineProperty wrapper, 'class',
          value: vcClass
          enumerable: yes
        Reflect.defineProperty lambda, 'class',
          value: vcClass
          enumerable: yes
        Reflect.defineProperty wrapper, 'name',
          value: vsName
          configurable: yes
        Reflect.defineProperty lambda, 'name',
          value: vsName
          configurable: yes
        Reflect.defineProperty wrapper, 'pointer',
          value: vsPointer
          configurable: yes
          enumerable: yes
        Reflect.defineProperty lambda, 'pointer',
          value: vsPointer
          configurable: yes
          enumerable: yes
        Reflect.defineProperty lambda, 'wrapper',
          value: wrapper
          enumerable: yes
        Reflect.defineProperty wrapper, 'body',
          value: lambda
          enumerable: yes

        wrapper

    Reflect.defineProperty @, 'metaObject',
      enumerable: yes
      configurable: yes
      get: -> @[cpoMetaObject]

    @[cplExtensibles][@[cpsExtensibleSymbol]] = yes

    Reflect.defineProperty @, 'inheritProtected',
      enumerable: yes
      value: (abNormal = yes) ->
        self = @
        superclass = @superclass() ? {}
        parent = if abNormal
          self.metaObject ? superclass.metaObject
        else
          superclass.metaObject
        Reflect.defineProperty self, cpoMetaObject,
          enumerable: no
          configurable: yes
          value: new RC::MetaObject self, parent
        Reflect.defineProperty self, cpsExtensibleSymbol,
          enumerable: no
          configurable: yes
          value: Symbol 'extensibleSymbol'
        self[cplExtensibles][self[cpsExtensibleSymbol]] = yes
        return

    Reflect.defineProperty @, 'new',
      enumerable: yes
      configurable: yes
      value: (args...)->
        Reflect.construct @, args

    Reflect.defineProperty @, 'include',
      enumerable: yes
      value: (mixins...)->
        if Array.isArray mixins[0]
          mixins = mixins[0]
        mixins.forEach (mixin)=>
          assert mixin?, 'Supplied mixin was not found'
          assert _.isFunction(mixin), 'Mixin must be a function'

          SuperClass = Reflect.getPrototypeOf @
          Mixin = mixin SuperClass
          Reflect.defineProperty Mixin, 'name',
            value: mixin.name

          Reflect.setPrototypeOf @, Mixin
          Reflect.setPrototypeOf @::, Mixin::

          Mixin.including?.call @
          @inheritProtected no
          @metaObject.addMetaData 'mixins', mixin.name, mixin
        @

    Reflect.defineProperty @, 'implements',
      enumerable: yes
      value: (interfaces...)->
        if Array.isArray interfaces[0]
          interfaces = interfaces[0]
        interfaces.forEach (iface)=>
          for own k, config of iface.classVirtualVariables
            @metaObject.addMetaData 'classVirtualVariables', k, config
          for own k, config of iface.classVirtualMethods
            @metaObject.addMetaData 'classVirtualMethods', k, config
          for own k, config of iface.instanceVirtualVariables
            @metaObject.addMetaData 'instanceVirtualVariables', k, config
          for own k, config of iface.instanceVirtualMethods
            @metaObject.addMetaData 'instanceVirtualMethods', k, config
          for own k, config of iface.constants
            @[cpmDefineProperty] config
          @metaObject.addMetaData 'interfaces', iface.name, iface
        @

    Reflect.defineProperty @, 'freeze',
      enumerable: yes
      configurable: no
      value: ->
        @[cplExtensibles][@[cpsExtensibleSymbol]] = no
        @

    Reflect.defineProperty @, 'subtypeOf',
      enumerable: yes
      configurable: no
      value: (attr, kind, member, Type, ParentTypes)->
        return unless (@Module?::?isSubsetOf)?
        isStatic = kind is 'static'
        isMethod = member is 'method'
        ParentTypes = _.castArray ParentTypes
        for ParentType in ParentTypes
          assert @Module::isSubsetOf(Type, ParentType), "Type definition #{@Module::getTypeName Type} must be subset of #{@name}#{if isStatic then '.' else '::'}#{attr}#{if isMethod then '' else ': '}#{@Module::getTypeName ParentType}"
        return

    Reflect.defineProperty @, 'initialize',
      enumerable: yes
      configurable: yes
      value: ->
        @constructor = RC::Class
        assert _.isFunction(@Module.const), "Module of #{@name} must be subclass of RC::Module"

        if @Module.environment isnt PRODUCTION
          {
            classVariables
            classMethods
            instanceVariables
            instanceMethods
          } = @

          SuperClass = Reflect.getPrototypeOf @
          if SuperClass?
            {
              classVariables: superClassVariables
              classMethods: superClassMethods
              instanceVariables: superInstanceVariables
              instanceMethods: superInstanceMethods
            } = SuperClass

          for own k, {attrType} of @classVirtualVariables
            assert classVariables[k]?, "Absent implementation for virtual #{@name}.#{k}"
            Type = classVariables[k].attrType
            pts = [attrType]
            if SuperClass? and (superAttrType = superClassVariables[k]?.attrType)?
              pts.push superAttrType
            @subtypeOf k, 'static', 'variable', Type, pts
            # assert @Module::isSubsetOf(Type, attrType), "Type definition #{@Module::getTypeName Type} must be subset of virtual #{@name}.#{k}: #{@Module::getTypeName attrType}"
            # if SuperClass? and (superAttrType = superClassVariables[k]?.attrType)?
            #   @subtypeOf k, 'static', 'variable', Type, superAttrType
              # assert @Module::isSubsetOf(Type, superAttrType), "Type definition #{@Module::getTypeName Type} must be subset of parent #{@name}.#{k}: #{@Module::getTypeName superAttrType}"
          for own k, {attrType} of @classVirtualMethods
            assert classMethods[k]?, "Absent implementation for virtual #{@name}.#{k}()"
            Type = classMethods[k].attrType
            pts = [attrType]
            if SuperClass? and (superAttrType = superClassMethods[k]?.attrType)?
              pts.push superAttrType
            @subtypeOf k, 'static', 'method', Type, pts
            # assert @Module::isSubsetOf(Type, attrType), "Type definition #{@Module::getTypeName Type} must be subset of virtual #{@name}.#{k}#{@Module::getTypeName attrType}"
            # if SuperClass? and (superAttrType = superClassMethods[k]?.attrType)?
            #   @subtypeOf k, 'static', 'method', Type, superAttrType
              # assert @Module::isSubsetOf(Type, superAttrType), "Type definition #{@Module::getTypeName Type} must be subset of parent #{@name}.#{k}#{@Module::getTypeName superAttrType}"
          for own k, {attrType} of @instanceVirtualVariables
            assert instanceVariables[k]?, "Absent implementation for virtual #{@name}::#{k}"
            Type = instanceVariables[k].attrType
            pts = [attrType]
            if SuperClass? and (superAttrType = superInstanceVariables[k]?.attrType)?
              pts.push superAttrType
            @subtypeOf k, 'instance', 'variable', Type, pts
            # assert @Module::isSubsetOf(Type, attrType), "Type definition #{@Module::getTypeName Type} must be subset of virtual #{@name}::#{k}: #{@Module::getTypeName attrType}"
            # if SuperClass? and (superAttrType = superInstanceVariables[k]?.attrType)?
            #   @subtypeOf k, 'instance', 'variable', Type, superAttrType
              # assert @Module::isSubsetOf(Type, superAttrType), "Type definition #{@Module::getTypeName Type} must be subset of parent #{@name}::#{k}: #{@Module::getTypeName superAttrType}"
          for own k, {attrType} of @instanceVirtualMethods
            assert instanceMethods[k]?, "Absent implementation for virtual #{@name}::#{k}()"
            Type = instanceMethods[k].attrType
            pts = [attrType]
            if SuperClass? and (superAttrType = superInstanceMethods[k]?.attrType)?
              pts.push superAttrType
            @subtypeOf k, 'instance', 'method', Type, pts
            # assert @Module::isSubsetOf(Type, attrType), "Type definition #{@Module::getTypeName Type} must be subset of virtual #{@name}::#{k}#{@Module::getTypeName attrType}"
            # if SuperClass? and (superAttrType = superInstanceMethods[k]?.attrType)?
            #   @subtypeOf k, 'instance', 'method', Type, superAttrType
              # assert @Module::isSubsetOf(Type, superAttrType), "Type definition #{@Module::getTypeName Type} must be subset of parent #{@name}::#{k}#{@Module::getTypeName superAttrType}"

        if @Module isnt @ or @name is 'Module'
          @Module.const "#{@name}": @
        @

    Reflect.defineProperty @, 'initializeMixin',
      enumerable: yes
      configurable: yes
      value: ->
        @constructor = RC::Class
        @

    Reflect.defineProperty @, cpmDefineProperty,
      enumerable: yes
      value: (config = {})->
        {
          level, type, async, const:constant
          attr, attrType
          default:_default, get, set, configurable
          isFunction
          isUtility = no
        } = config

        assert @isExtensible, "Class '#{@name}' has been frozen previously. Property '#{attr}' can not be declared"

        isVirtual   = level     is VIRTUAL
        isPublic    = level     is PUBLIC
        isPrivate   = level     is PRIVATE
        isProtected = level     is PROTECTED
        isStatic    = type      is STATIC
        isConstant  = constant  is CONST
        isAsync     = async     is ASYNC

        if isVirtual
          if isStatic
            if isFunction
              @metaObject.addMetaData 'classVirtualMethods', attr, config
            else
              @metaObject.addMetaData 'classVirtualVariables', attr, config
          else
            if isFunction
              @metaObject.addMetaData 'instanceVirtualMethods', attr, config
            else
              @metaObject.addMetaData 'instanceVirtualVariables', attr, config
          return attr

        target = if isStatic then @ else @::
        name = if isPublic
          attr
        else if isProtected
          Symbol.for attr
        else
          Symbol attr
        config.pointer = name
        definition =
          enumerable: yes
          configurable: configurable ? yes

        sepor = if isStatic then '.' else '::'
        # Type = if isStatic
        #   if isFunction
        #     @classVirtualMethods[attr]
        #   else
        #     @classVirtualVariables[attr]
        # else
        #   if isFunction
        #     @instanceVirtualMethods[attr]
        #   else
        #     @instanceVirtualVariables[attr]
        # Type ?= attrType
        Type = attrType

        attrKind = if isStatic
          'static'
        else
          'instance'
        memberKind = if isFunction
          'method'
        else
          'variable'

        ParentType = if isStatic
          if isFunction
            @classMethods[attr]
          else
            @classVariables[attr]
        else
          if isFunction
            @instanceMethods[attr]
          else
            @instanceVariables[attr]

        ParentType ?= if isStatic
          if isFunction
            @classVirtualMethods[attr]
          else
            @classVirtualVariables[attr]
        else
          if isFunction
            @instanceVirtualMethods[attr]
          else
            @instanceVirtualVariables[attr]

        if isFunction
          if @Module.environment isnt PRODUCTION
            @subtypeOf attr, attrKind, memberKind, Type, ParentType
          Reflect.defineProperty _default, 'class',
            value: @
            enumerable: yes
          Reflect.defineProperty _default, 'name',
            value: attr
            configurable: yes
          Reflect.defineProperty _default, 'pointer',
            value: name
            configurable: yes
            enumerable: yes

          checkTypesWrapper = (args...)->
            className = if isStatic then @name else @constructor.name
            if @Module.environment isnt PRODUCTION
              @Module::FunctionT _default
              if @Module::FunctionT isnt Type and @Module::FunctorT.is(Type) and Type.meta.domain.length > 0
                argsLength = args.length
                optionalArgumentsIndex = @Module::getOptionalArgumentsIndex Type.meta.domain
                # tupleLength = Math.max argsLength, optionalArgumentsIndex
                tupleLength = optionalArgumentsIndex
                @Module::TupleG(Type.meta.domain.slice(0, tupleLength))(args.slice(0, optionalArgumentsIndex), ["#{className}#{sepor}#{attr}#{Type.meta.name}"])
            self = @
            if isAsync
              co = @Module::co ? RC::co
              co ->
                data = yield from _default.apply self, args
                if self.Module.environment isnt PRODUCTION
                  if self.Module::FunctionT isnt Type and self.Module::FunctorT.is Type
                    self.Module::createByType Type.meta.codomain, data, ["#{className}#{sepor}#{attr}#{Type.meta.name}"]
                return data
            else
              data = _default.apply @, args
              if self.Module.environment isnt PRODUCTION
                if self.Module::FunctionT isnt Type and self.Module::FunctorT.is Type
                  self.Module::createByType Type.meta.codomain, data, ["#{className}#{sepor}#{attr}#{Type.meta.name}"]
              return data

          Reflect.defineProperty _default, 'wrapper',
            value: checkTypesWrapper
            enumerable: yes
          Reflect.defineProperty checkTypesWrapper, 'class',
            value: @
            enumerable: yes
          Reflect.defineProperty checkTypesWrapper, 'name',
            value: attr
            configurable: yes
          Reflect.defineProperty checkTypesWrapper, 'pointer',
            value: name
            configurable: yes
            enumerable: yes
          Reflect.defineProperty checkTypesWrapper, 'body',
            value: _default
            enumerable: yes

          definition.value = checkTypesWrapper
          config.wrapper = checkTypesWrapper
        else if isConstant
          definition.writable = no
          definition.value = _default
        else
          if @Module.environment isnt PRODUCTION
            @subtypeOf attr, attrKind, memberKind, Type, ParentType
          pointerOnRealPlace = Symbol "_#{attr}"
          if _default?
            Type? _default, ["#{@name}#{sepor}#{attr}"]
            target[pointerOnRealPlace] = _default
          # TODO: сделать оптимизацию: если getter и setter не указаны,
          # то не использовать getter и setter, а объявлять через value
          definition.get = ->
            className = if isStatic then @name else @constructor.name
            value = @[pointerOnRealPlace]
            if get? and _.isFunction get
              value = get.apply @, [value]
            Type? value, ["#{className}#{sepor}#{attr}"]
            return value
          definition.set = (newValue)->
            className = if isStatic then @name else @constructor.name
            if set? and _.isFunction set
              newValue = set.apply @, [newValue]
            Type? newValue, ["#{className}#{sepor}#{attr}"]
            @[pointerOnRealPlace] = newValue
            return newValue

        Reflect.defineProperty target, name, definition
        if isConstant
          @metaObject.addMetaData 'constants', attr, config
        else if isStatic
          if isFunction
            @metaObject.addMetaData 'classMethods', attr, config
          else
            @metaObject.addMetaData 'classVariables', attr, config
        else
          if isUtility
            @metaObject.addMetaData 'utilities', attr, config
          else if isFunction
            @metaObject.addMetaData 'instanceMethods', attr, config
          else
            @metaObject.addMetaData 'instanceVariables', attr, config
        return name

    # метод, чтобы объявить асинхронный метод класса или инстанса
    # этот метод возвращает промис, а оберточная функция, которая будет делать проверку типов входящих и возвращаемых значений тоже будет ретурнить промис, а внутри будет использовать yield для ожидания резолва обворачиваемой функции
    Reflect.defineProperty @, 'async',
      enumerable: yes
      value: (args...)->
        assert args.length > 0, 'arguments is required'
        [typeDefinition] = args
        assert _.isPlainObject(typeDefinition), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to async(typeDefinition) (expected a plain object or @static definition)"

        config = if args.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          # typeDefinition.attrType = @Module::AccordG typeDefinition.attrType
          typeDefinition
        else
          attr = Object.keys(typeDefinition)[0]
          attrType = typeDefinition[attr]
          definition = args[1] ? {}

          if attrType is Function
            attrType = @Module::FuncG definition.args, definition.return
          else
            attrType = @Module::AccordG attrType

          isFunction = attrType in [
            @Module::FunctionT
            @Module::AsyncFunctionT
            @Module::GeneratorFunctionT
          ] or @Module::FunctorT.is attrType
          definition.attr = attr
          definition.attrType = attrType
          definition.isFunction = isFunction
          definition

        config.async = ASYNC
        return config

    # метод чтобы объявить атрибут или метод класса
    Reflect.defineProperty @, 'static',
      enumerable: yes
      value: (args...)->
        assert args.length > 0, 'arguments is required'
        [typeDefinition] = args
        assert _.isPlainObject(typeDefinition), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to static(typeDefinition) (expected a plain object or @async definition)"

        config = if args.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          # typeDefinition.attrType = @Module::AccordG typeDefinition.attrType
          typeDefinition
        else
          attr = Object.keys(typeDefinition)[0]
          attrType = typeDefinition[attr]
          definition = args[1] ? {}

          if attrType is Function
            attrType = @Module::FuncG definition.args, definition.return
          else
            attrType = @Module::AccordG attrType

          isFunction = attrType in [
            @Module::FunctionT
            @Module::AsyncFunctionT
            @Module::GeneratorFunctionT
          ] or @Module::FunctorT.is attrType
          definition.attr = attr
          definition.attrType = attrType
          definition.isFunction = isFunction
          definition

        config.type = STATIC
        return config

    Reflect.defineProperty @, 'public',
      enumerable: yes
      value: (args...)->
        assert args.length > 0, 'arguments is required'
        [typeDefinition] = args
        assert _.isPlainObject(typeDefinition), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to public(typeDefinition) (expected a plain object or @static or/and @async definition)"

        config = if args.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          # typeDefinition.attrType = @Module::AccordG typeDefinition.attrType
          hasBody = (_.isPlainObject(typeDefinition) and typeDefinition?.default?)
          assert not(typeDefinition.isFunction and not hasBody), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to public(typeDefinition) (expected a plain object with {default: () => {}})"
          typeDefinition
        else
          attr = Object.keys(typeDefinition)[0]
          attrType = typeDefinition[attr]
          definition = args[1] ? {}

          if attrType is Function
            attrType = @Module::FuncG definition.args, definition.return
          else
            attrType = @Module::AccordG attrType

          isFunction = attrType in [
            @Module::FunctionT
            @Module::AsyncFunctionT
            @Module::GeneratorFunctionT
          ] or @Module::FunctorT.is attrType
          hasBody = (_.isPlainObject(args[1]) and args[1]?.default?)
          assert not(isFunction and not hasBody), "Invalid argument config #{assert.stringify args[1]} supplied to public(typeDefinition, config) (expected a plain object with {default: () => {}})"
          definition.attr = attr
          definition.attrType = attrType
          definition.isFunction = isFunction
          definition

        config.level = PUBLIC
        @[cpmDefineProperty] config

    # NOTE: like public but outter objects does not get data or call methods
    Reflect.defineProperty @, 'protected',
      enumerable: yes
      value: (args...)->
        assert args.length > 0, 'arguments is required'
        [typeDefinition] = args
        assert _.isPlainObject(typeDefinition), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to protected(typeDefinition) (expected a plain object or @static or/and @async definition)"

        config = if args.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          # typeDefinition.attrType = @Module::AccordG typeDefinition.attrType
          hasBody = (_.isPlainObject(typeDefinition) and typeDefinition?.default?)
          assert not(typeDefinition.isFunction and not hasBody), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to protected(typeDefinition) (expected a plain object with {default: () => {}})"
          typeDefinition
        else
          attr = Object.keys(typeDefinition)[0]
          attrType = typeDefinition[attr]
          definition = args[1] ? {}

          if attrType is Function
            attrType = @Module::FuncG definition.args, definition.return
          else
            attrType = @Module::AccordG attrType

          isFunction = attrType in [
            @Module::FunctionT
            @Module::AsyncFunctionT
            @Module::GeneratorFunctionT
          ] or @Module::FunctorT.is attrType
          hasBody = (_.isPlainObject(args[1]) and args[1]?.default?)
          assert not(isFunction and not hasBody), "Invalid argument config #{assert.stringify args[1]} supplied to protected(typeDefinition, config) (expected a plain object with {default: () => {}})"
          definition.attr = attr
          definition.attrType = attrType
          definition.isFunction = isFunction
          definition

        unless /^[~]/.test config.attr
          config.attr = '~' + config.attr

        config.level = PROTECTED
        @[cpmDefineProperty] config

    # NOTE: like public but outter objects does not get data or call methods
    Reflect.defineProperty @, 'private',
      enumerable: yes
      value: (args...)->
        assert args.length > 0, 'arguments is required'
        [typeDefinition] = args
        assert _.isPlainObject(typeDefinition), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to private(typeDefinition) (expected a plain object or @static or/and @async definition)"

        config = if args.length is 1 and typeDefinition.attr? and typeDefinition.attrType?
          # typeDefinition.attrType = @Module::AccordG typeDefinition.attrType
          hasBody = (_.isPlainObject(typeDefinition) and typeDefinition?.default?)
          assert not(typeDefinition.isFunction and not hasBody), "Invalid argument typeDefinition #{assert.stringify typeDefinition} supplied to private(typeDefinition) (expected a plain object with {default: () => {}})"
          typeDefinition
        else
          attr = Object.keys(typeDefinition)[0]
          attrType = typeDefinition[attr]
          definition = args[1] ? {}

          if attrType is Function
            attrType = @Module::FuncG definition.args, definition.return
          else
            attrType = @Module::AccordG attrType

          isFunction = attrType in [
            @Module::FunctionT
            @Module::AsyncFunctionT
            @Module::GeneratorFunctionT
          ] or @Module::FunctorT.is attrType
          hasBody = (_.isPlainObject(args[1]) and args[1]?.default?)
          assert not(isFunction and not hasBody), "Invalid argument config #{assert.stringify args[1]} supplied to private(typeDefinition, config) (expected a plain object with {default: () => {}})"
          definition.attr = attr
          definition.attrType = attrType
          definition.isFunction = isFunction
          definition

        unless /^[_]/.test config.attr
          config.attr = '_' + config.attr

        config.level = PRIVATE
        @[cpmDefineProperty] config

    Reflect.defineProperty @, 'const',
      enumerable: yes
      value: (definition)->
        assert _.isPlainObject(definition), "Invalid argument definition #{assert.stringify definition} supplied to const(definition) (expected a plain object)"
        attr = Object.keys(definition)[0]
        @[cpmDefineProperty] {
          attr
          attrType: null
          const: CONST
          level: PUBLIC
          configurable: no
          default: definition[attr]
        }

    # @Module: RC

    # General class API

    Reflect.defineProperty @, 'module',
      enumerable: yes
      value: (module)-> @Module = module

    Reflect.defineProperty @::, 'Module',
      enumerable: yes
      get: -> @constructor.Module

    Reflect.defineProperty @, 'moduleName',
      enumerable: yes
      value: -> @Module.name

    Reflect.defineProperty @::, 'moduleName',
      enumerable: yes
      value: -> @Module.name

    Reflect.defineProperty @::, 'CLASS_KEYS',
      writable: no
      configurable: no
      enumerable: yes
      value: CLASS_KEYS

    Reflect.defineProperty @::, 'INSTANCE_KEYS',
      writable: no
      configurable: no
      enumerable: yes
      value: INSTANCE_KEYS

    @metaObject.addMetaData 'constants', 'CLASS_KEYS', {
      attr: 'CLASS_KEYS'
      attrType: Array
      const: CONST
      configurable: no
      default: CLASS_KEYS
    }

    @metaObject.addMetaData 'constants', 'INSTANCE_KEYS', {
      attr: 'INSTANCE_KEYS'
      attrType: Array
      const: CONST
      configurable: no
      default: INSTANCE_KEYS
    }

    Reflect.defineProperty @, 'superclass',
      enumerable: yes
      value: -> Reflect.getPrototypeOf @

    Reflect.defineProperty @, 'class',
      enumerable: yes
      value: -> @constructor

    Reflect.defineProperty @::, 'class',
      enumerable: yes
      value: -> @constructor

    Reflect.defineProperty @, 'mixins',
      enumerable: yes
      get: -> @metaObject.getGroup 'mixins', no

    Reflect.defineProperty @, 'interfaces',
      enumerable: yes
      get: -> @metaObject.getGroup 'interfaces', no

    Reflect.defineProperty @, 'classMethods',
      enumerable: yes
      get: -> @metaObject.getGroup 'classMethods', no

    Reflect.defineProperty @, 'instanceMethods',
      enumerable: yes
      get: -> @metaObject.getGroup 'instanceMethods', no

    Reflect.defineProperty @, 'classVirtualMethods',
      enumerable: yes
      get: -> @metaObject.getGroup 'classVirtualMethods', no

    Reflect.defineProperty @, 'instanceVirtualMethods',
      enumerable: yes
      get: -> @metaObject.getGroup 'instanceVirtualMethods', no

    Reflect.defineProperty @, 'constants',
      enumerable: yes
      get: -> @metaObject.getGroup 'constants', no

    Reflect.defineProperty @, 'instanceVariables',
      enumerable: yes
      get: -> @metaObject.getGroup 'instanceVariables', no

    Reflect.defineProperty @, 'classVariables',
      enumerable: yes
      get: -> @metaObject.getGroup 'classVariables', no

    Reflect.defineProperty @, 'instanceVirtualVariables',
      enumerable: yes
      get: -> @metaObject.getGroup 'instanceVirtualVariables', no

    Reflect.defineProperty @, 'classVirtualVariables',
      enumerable: yes
      get: -> @metaObject.getGroup 'classVirtualVariables', no

    Reflect.defineProperty @, 'restoreObject',
      enumerable: yes
      value: (Module, replica)->
        assert replica?, "Replica cann`t be empty"
        assert replica.class?, "Replica type is required"
        assert replica?.type is 'instance', "Replica type isn`t `instance`. It is `#{replica.type}`"
        co = @Module::co ? RC::co
        self = @
        return co ->
          instance = if replica.class is self.name
            self.new()
          else
            vcClass = Module::[replica.class]
            # vcClass.classMethods['restoreObject'].async is ASYNC
            yield vcClass.restoreObject Module, replica
            # else
            #   vcClass.restoreObject Module, replica
          yield return instance

    Reflect.defineProperty @, 'replicateObject',
      enumerable: yes
      value: (aoInstance)->
        assert aoInstance?, "Argument cann`t be empty"
        replica =
          type: 'instance'
          class: aoInstance.constructor.name
        (@Module::Promise ? RC::Promise).resolve replica

    # дополнительно можно объявить:
    # privateClassMethods, protectedClassMethods, publicClassMethods
    # privateInstanceMethods, protectedInstanceMethods, publicInstanceMethods
    # privateClassVariables, protectedClassVariables, publicClassVariables
    # privateInstanceVariables, protectedInstanceVariables, publicInstanceVariables

    Reflect.defineProperty @::, 'init',
      enumerable: yes
      value: (args...) -> @

    Reflect.defineProperty @, 'displayName',
      configurable: no
      enumerable: yes
      get: -> @name

    Reflect.defineProperty @, 'meta',
      configurable: no
      enumerable: yes
      get: -> {
        kind: 'class'
        name: @name
        identity: yes
      }

    @module RC

  require('./Class') RC
  RC::CoreObject.constructor = RC::Class
  RC::MetaObject.constructor = RC::Class

  return RC::CoreObject
