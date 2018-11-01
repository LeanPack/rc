# Есть понимание что Interface, Struct and Class НЕ тождественные понятия.
# если описывается класс в его конструкторе может быть передано что угодно, таким образом проводится создание инстанса класса.
# описание Struct не подходит для проверки инстансов классов и наоборот, т.к. instanceof вернут в обоих случаях false
# проверка же интерфейса хоть и осуществляет проверку "вроде бы правильно", но опосредованно, т.к. переданный объект может не являться инстансом именно этого "Interface"а - задача интерфейса обеспечить полиморфизм

# таким образом, если надо проверить некоторый объект, как инстанс подкласса Object нужно воспользоваться именно этим Struct генериком.

# struct генерик нужено использовать в тех случаях, когда надо объявить тип для структуры, в которой должны быть определенные имена ключей с определенными (не одинаковыми) типами значений.

# при этом по функционированию struct не будет отличаться принципиально от интерфейса кроме 2 пунктов:
# - в отличие от интерфейса проверка имен ключей будет прозводиться 'строго', т.е. в проверяемом объекте должны быть строго только те ключи, которые объявлены в struct И НЕ БОЛЕЕ.
# - семантически, т.е. struct НЕ ДОЛЖЕН использоваться для проверки инстансов классов и самих классов - для них должен использоваться интерфейс, в то время как любые сложные (не словари) объекты "не инстансы кастомных классов" должны проверяться именно struct'ами.

# NOTE: options.defaultProps не добавляем, т.к. Struct не должен инстанцировать объекты через new, а должен только проверить в строгом режиме уже существующие объекты, а следовательно ленивое описание дефолтов не может быть использовано.
# NOTE: options вторым аргументом не принимаем, т.к. defaultProps не должен быть, а strict - по умолчанию всегда true, name - как и во всех других генериках не передаем.


module.exports = (Module)->
  {
    PRODUCTION
    Generic
    Utils: {
      _
      t
      getTypeName
      createByType
    }
  } = Module::

  { assert } = t

  cache = new Map()

  Module.defineGeneric Generic 'StructG', (props) ->
    if Module.environment isnt PRODUCTION
      assert Module::DictG(String, Function).is(props), "Invalid argument props #{assert.stringify props} supplied to StructG(props) (expected a dictionary String -> Type)"

    new_props = {}
    for own k, ValueType of props
      new_props[k] = Module::AccordG ValueType

    props = new_props

    displayName = "Struct{#{(
      for own k, v of props
        "#{k}: #{getTypeName v}"
    ).join ', '}}"

    if (cachedType = cache.get displayName)?
      return cachedType

    Struct = (value, path)->
      if Module.environment is PRODUCTION
        return value
      Struct.isNotSample @
      path ?= [Struct.displayName]
      assert _.isPlainObject(value), "Invalid value #{assert.stringify value} supplied to #{path.join '.'} (expected a plain object)"
      for own k of value
        assert props.hasOwnProperty(k), "Invalid prop \"#{k}\" supplied to #{path.join '.'}"
      for own k, expected of props
        assert value.hasOwnProperty(k), "Invalid prop \"#{k}\" supplied to #{path.join '.'}"
        actual = value[k]
        createByType expected, actual, path.concat "#{k}: #{getTypeName expected}"
      return value

    Reflect.defineProperty Struct, 'name',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Struct, 'displayName',
      configurable: no
      enumerable: yes
      writable: no
      value: displayName

    Reflect.defineProperty Struct, 'is',
      configurable: no
      enumerable: yes
      writable: no
      value: (x)->
        _.isPlainObject(x) and (
          res = yes
          for own k of x
            res = res and props.hasOwnProperty k
          for own k, v of props
            res = res and x.hasOwnProperty k
            res = res and t.is x[k], v
          res
        )

    Reflect.defineProperty Struct, 'meta',
      configurable: no
      enumerable: yes
      writable: no
      value: {
        kind: 'interface'
        props: props
        name: Struct.displayName
        identity: yes
        strict: yes
      }

    Reflect.defineProperty Struct, 'isNotSample',
      configurable: no
      enumerable: yes
      writable: no
      value: Module::NotSampleG Struct

    cache.set displayName, Struct

    Struct