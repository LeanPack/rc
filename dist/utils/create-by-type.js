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
    var PRODUCTION, assert, getTypeName, instanceOf;
    ({
      PRODUCTION,
      Utils: {
        t: {assert},
        getTypeName,
        instanceOf
      }
    } = Module.prototype);
    return Module.util({
      createByType: function(type, value, path) {
        if (Module.environment === PRODUCTION) {
          return value;
        }
        if (Module.prototype.TypeT.is(type)) {
          // if not type.meta.identity and typeof value is 'object' and value isnt null
          //   return new type(value, path)
          // else
          return type(value, path);
        }
        path = path != null ? path : [getTypeName(type)];
        assert(instanceOf(value, type), `Invalid value ${assert.stringify(value)} supplied to ${path.join('.')}`);
        return value;
      }
    });
  };

}).call(this);
