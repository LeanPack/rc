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
  module.exports = function(Module) {
    var CACHE, Generic, PRODUCTION, WEAK, _, assert, createByType, getTypeName, typesCache, valueIsType;
    ({
      PRODUCTION,
      CACHE,
      WEAK,
      Generic,
      Utils: {
        _,
        t: {assert},
        getTypeName,
        createByType,
        valueIsType
      }
    } = Module.prototype);
    typesCache = new Map();
    return Module.defineGeneric(Generic('SetG', function(Type) {
      var SetID, _Set, cachedType, displayName, typeNameCache;
      Type = Module.prototype.AccordG(Type);
      if (Module.environment !== PRODUCTION) {
        assert(_.isFunction(Type), `Invalid argument Type ${assert.stringify(Type)} supplied to SetG(Type) (expected a function)`);
      }
      typeNameCache = getTypeName(Type);
      displayName = `Set< ${typeNameCache} >`;
      SetID = `Set< ${Type.ID} >`;
      if ((cachedType = typesCache.get(SetID)) != null) {
        return cachedType;
      }
      _Set = function(value, path) {
        if (Module.environment === PRODUCTION) {
          return value;
        }
        _Set.isNotSample(this);
        if (_Set.has(value)) {
          return value;
        }
        if (path == null) {
          path = [_Set.displayName];
        }
        assert(_.isSet(value), `Invalid value ${assert.stringify(value)} supplied to ${path.join('.')} (expected an set of ${typeNameCache})`);
        value.forEach(function(actual, i) {
          return createByType(Type, actual, path.concat(`${i}: ${typeNameCache}`));
        });
        _Set.keep(value);
        return value;
      };
      // Reflect.defineProperty _Set, 'cache',
      //   configurable: no
      //   enumerable: yes
      //   writable: no
      //   value: new Set()
      Reflect.defineProperty(_Set, 'cacheStrategy', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: WEAK
      });
      Reflect.defineProperty(_Set, 'ID', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: SetID
      });
      Module.prototype.WEAK_CACHE.set(SetID, new WeakSet());
      Reflect.defineProperty(_Set, 'has', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(value) {
          return Module.prototype.WEAK_CACHE.get(SetID).has(value);
        }
      });
      Reflect.defineProperty(_Set, 'keep', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(value) {
          return Module.prototype.WEAK_CACHE.get(SetID).add(value);
        }
      });
      Reflect.defineProperty(_Set, 'name', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: displayName
      });
      Reflect.defineProperty(_Set, 'displayName', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: displayName
      });
      Reflect.defineProperty(_Set, 'is', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(x) {
          var res, result;
          if (_Set.has(x)) {
            return true;
          }
          result = _.isSet(x) && (res = true, x.forEach(function(e) {
            return res = res && valueIsType(e, Type);
          }), res);
          if (result) {
            _Set.keep(x);
          }
          return result;
        }
      });
      Reflect.defineProperty(_Set, 'meta', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: {
          kind: 'set',
          type: Type,
          name: _Set.displayName,
          identity: true
        }
      });
      Reflect.defineProperty(_Set, 'isNotSample', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: Module.prototype.NotSampleG(_Set)
      });
      typesCache.set(SetID, _Set);
      CACHE.set(_Set, SetID);
      return _Set;
    }));
  };

}).call(this);