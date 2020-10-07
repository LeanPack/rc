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

  // Основное назначение словаря - объявить тип такой структуры, в которой все значения строго одного типа. А struct генерик нужено использовать в тех случаях, когда надо объявить тип для структуры, в которой должны быть определенные имена ключей с определенными (не одинаковыми) типами значений.
  var hasProp = {}.hasOwnProperty;

  module.exports = function(Module) {
    var CACHE, Generic, PRODUCTION, WEAK, _, assert, createByType, getTypeName, typesCache, valueIsType;
    ({
      PRODUCTION,
      CACHE,
      WEAK,
      Generic,
      Utils: {
        _,
        // uuid
        t: {assert},
        getTypeName,
        createByType,
        valueIsType
      }
    } = Module.prototype);
    typesCache = new Map();
    return Module.defineGeneric(Generic('DictG', function(KeyType, ValueType) {
      var Dict, DictID, cachedType, displayName, keyTypeNameCache, valueTypeNameCache;
      KeyType = Module.prototype.AccordG(KeyType);
      ValueType = Module.prototype.AccordG(ValueType);
      if (Module.environment !== PRODUCTION) {
        assert(_.isFunction(KeyType), `Invalid argument KeyType ${assert.stringify(KeyType)} supplied to DictG(KeyType, ValueType) (expected a function)`);
        assert(_.isFunction(ValueType), `Invalid argument ValueType ${assert.stringify(ValueType)} supplied to DictG(KeyType, ValueType) (expected a function)`);
      }
      keyTypeNameCache = getTypeName(KeyType);
      valueTypeNameCache = getTypeName(ValueType);
      displayName = `{[key: ${keyTypeNameCache}]: ${valueTypeNameCache}}`;
      DictID = `{[key: ${KeyType.ID}]: ${ValueType.ID}}`;
      // _ids = []
      // unless (id = CACHE.get KeyType)?
      //   id = uuid.v4()
      //   CACHE.set KeyType, id
      // _ids.push id
      // unless (id = CACHE.get ValueType)?
      //   id = uuid.v4()
      //   CACHE.set ValueType, id
      // _ids.push id
      // DictID = _ids.join()
      if ((cachedType = typesCache.get(DictID)) != null) {
        return cachedType;
      }
      Dict = function(value, path) {
        var _k, i, k, len, ref, s, v;
        if (Module.environment === PRODUCTION) {
          return value;
        }
        Dict.isNotSample(this);
        if (Dict.has(value)) {
          return value;
        }
        if (path == null) {
          path = [Dict.displayName];
        }
        assert(_.isPlainObject(value), `Invalid value ${assert.stringify(value)} supplied to ${path.join('.')} (expected {[key: ${keyTypeNameCache}]: ${valueTypeNameCache}})`);
        if (Module.prototype.SymbolT === KeyType) {
          ref = Object.getOwnPropertySymbols(value);
          for (i = 0, len = ref.length; i < len; i++) {
            s = ref[i];
            createByType(KeyType, s, path.concat(keyTypeNameCache));
            v = value[s];
            _k = Symbol.keyFor(s);
            createByType(ValueType, v, path.concat(`${_k}: ${valueTypeNameCache}`));
          }
        } else {
          for (k in value) {
            if (!hasProp.call(value, k)) continue;
            v = value[k];
            createByType(KeyType, k, path.concat(keyTypeNameCache));
            createByType(ValueType, v, path.concat(`${k}: ${valueTypeNameCache}`));
          }
        }
        Dict.keep(value);
        return value;
      };
      // Reflect.defineProperty Dict, 'cache',
      //   configurable: no
      //   enumerable: yes
      //   writable: no
      //   value: new Set()
      Reflect.defineProperty(Dict, 'cacheStrategy', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: WEAK
      });
      Reflect.defineProperty(Dict, 'ID', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: DictID
      });
      Module.prototype.WEAK_CACHE.set(DictID, new WeakSet());
      Reflect.defineProperty(Dict, 'has', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(value) {
          return Module.prototype.WEAK_CACHE.get(DictID).has(value);
        }
      });
      Reflect.defineProperty(Dict, 'keep', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(value) {
          return Module.prototype.WEAK_CACHE.get(DictID).add(value);
        }
      });
      Reflect.defineProperty(Dict, 'name', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: displayName
      });
      Reflect.defineProperty(Dict, 'displayName', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: displayName
      });
      Reflect.defineProperty(Dict, 'is', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: function(x) {
          var k, res, result, s, v;
          if (Dict.has(x)) {
            return true;
          }
          result = _.isPlainObject(x) && ((function() {
            var i, len, ref;
            res = true;
            if (Module.prototype.SymbolT === KeyType) {
              ref = Object.getOwnPropertySymbols(x);
              for (i = 0, len = ref.length; i < len; i++) {
                s = ref[i];
                v = x[s];
                res = res && valueIsType(k, KeyType) && valueIsType(v, ValueType);
              }
            } else {
              for (k in x) {
                if (!hasProp.call(x, k)) continue;
                v = x[k];
                res = res && valueIsType(k, KeyType) && valueIsType(v, ValueType);
              }
            }
            return res;
          })());
          if (result) {
            Dict.keep(x);
          }
          return result;
        }
      });
      Reflect.defineProperty(Dict, 'meta', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: {
          kind: 'dict',
          domain: KeyType,
          codomain: ValueType,
          name: Dict.displayName,
          identity: true
        }
      });
      Reflect.defineProperty(Dict, 'isNotSample', {
        configurable: false,
        enumerable: true,
        writable: false,
        value: Module.prototype.NotSampleG(Dict)
      });
      // unless (subCache = typesCache.get KeyType)?
      //   subCache = new Map()
      //   typesCache.set KeyType, subCache
      // subCache.set ValueType, Dict
      typesCache.set(DictID, Dict);
      CACHE.set(Dict, DictID);
      return Dict;
    }));
  };

}).call(this);
