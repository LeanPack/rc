// Generated by CoffeeScript 2.5.1
(function() {
  // This file is part of RC.

  // RC is free software: you can redistribute it and/or modify
  // it under the terms of the GNU Lesser General Public License as published by
  // the Free Software Foundation, either version 3 of the License, or
  // (at your option) any later version.

  // RC is distributed in the hope that it will be useful,
  // but WITHOUT ANY WARRANTY; without even the implied warranty of
  // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  // GNU Lesser General Public License for more details.

  // You should have received a copy of the GNU Lesser General Public License
  // along with RC.  If not, see <https://www.gnu.org/licenses/>.
  var hasProp = {}.hasOwnProperty;

  module.exports = function(Module) {
    var CACHE, CoreObject, Generic, PRODUCTION, WEAK, _, assert, createByType, getTypeName, instanceOf, typesCache, valueIsType;
    ({
      PRODUCTION,
      CACHE,
      WEAK,
      CoreObject,
      Generic,
      Utils: {
        _,
        // uuid
        t: {assert},
        getTypeName,
        createByType,
        valueIsType,
        instanceOf
      }
    } = Module.prototype);
    // typesDict = new Map()
    typesCache = new Map();
    return Module.defineGeneric(Generic('InterfaceG', function(props) {
      var Interface, InterfaceID, T, ValueType, cachedType, displayName, k, new_props, t;
      if (Module.environment !== PRODUCTION) {
        assert(Module.prototype.DictG(String, Function).is(props), `Invalid argument props ${assert.stringify(props)} supplied to InterfaceG(props) (expected a dictionary String -> Type)`);
      }
      // _ids = []
      new_props = {};
      for (k in props) {
        if (!hasProp.call(props, k)) continue;
        ValueType = props[k];
        t = Module.prototype.AccordG(ValueType);
        // unless (id = CACHE.get k)?
        //   id = uuid.v4()
        //   CACHE.set k, id
        // _ids.push id
        // unless (id = CACHE.get t)?
        //   id = uuid.v4()
        //   CACHE.set t, id
        // _ids.push id
        new_props[k] = t;
      }
      // InterfaceID = _ids.join()
      props = new_props;
      displayName = `Interface{${((function() {
        var results;
        results = [];
        for (k in props) {
          if (!hasProp.call(props, k)) continue;
          T = props[k];
          results.push(`${k}: ${getTypeName(T)}`);
        }
        return results;
      })()).join(', ')}}`;
      InterfaceID = `Interface{${((function() {
        var results;
        results = [];
        for (k in props) {
          if (!hasProp.call(props, k)) continue;
          T = props[k];
          results.push(`${k}: ${T.ID}`);
        }
        return results;
      })()).join(', ')}}`;
      if ((cachedType = typesCache.get(InterfaceID)) != null) {
        return cachedType;
      }
      Interface = function(value, path) {
        var actual, expected;
        if (Module.environment === PRODUCTION) {
          return value;
        }
        Interface.isNotSample(this);
        if (Interface.has(value)) {
          return value;
        }
        if (path == null) {
          path = [Interface.displayName];
        }
        assert(value != null, `Invalid value ${assert.stringify(value)} supplied to ${path.join('.')}`);
        if (instanceOf(value, CoreObject) && value.constructor.isSupersetOf(props)) {
          Interface.keep(value);
          return value;
        }
        for (k in props) {
          if (!hasProp.call(props, k)) continue;
          expected = props[k];
          actual = value[k];
          createByType(expected, actual, path.concat(`${k}: ${getTypeName(expected)}`));
        }
        Interface.keep(value);
        return value;
      };
      // Reflect.defineProperty Interface, 'cache',
      //   configurable: no
      //   enumerable: yes
      //   writable: no
      //   value: new Set()
      Reflect.defineProperty(Interface, 'cacheStrategy', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: WEAK
      });
      Reflect.defineProperty(Interface, 'ID', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: InterfaceID
      });
      Module.prototype.WEAK_CACHE.set(InterfaceID, new WeakSet());
      Reflect.defineProperty(Interface, 'has', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(value) {
          return Module.prototype.WEAK_CACHE.get(InterfaceID).has(value);
        }
      });
      Reflect.defineProperty(Interface, 'keep', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(value) {
          return Module.prototype.WEAK_CACHE.get(InterfaceID).add(value);
        }
      });
      Reflect.defineProperty(Interface, 'name', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: displayName
      });
      Reflect.defineProperty(Interface, 'displayName', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: displayName
      });
      Reflect.defineProperty(Interface, 'is', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(x) {
          var v;
          if (x == null) {
            return false;
          }
          if (Interface.has(x)) {
            return true;
          }
          if (instanceOf(x, CoreObject) && x.constructor.isSupersetOf(props)) {
            Interface.keep(x);
            return true;
          }
          for (k in props) {
            if (!hasProp.call(props, k)) continue;
            v = props[k];
            if (!valueIsType(x[k], v)) {
              return false;
            }
          }
          Interface.keep(x);
          return true;
        }
      });
      Reflect.defineProperty(Interface, 'meta', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: {
          kind: 'interface',
          props: props,
          name: Interface.displayName,
          identity: true,
          strict: false
        }
      });
      Reflect.defineProperty(Interface, 'isNotSample', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: Module.prototype.NotSampleG(Interface)
      });
      typesCache.set(InterfaceID, Interface);
      CACHE.set(Interface, InterfaceID);
      return Interface;
    }));
  };

}).call(this);