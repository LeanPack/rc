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
  module.exports = function(RC) {
    return RC.util({
      map: function*(items, lambda, context) {
        var i, index, item, len, result;
        result = [];
        for (index = i = 0, len = items.length; i < len; index = ++i) {
          item = items[index];
          yield* (function*(item, index, items, context) {
            return result.push((yield* lambda.call(context, item, index, items)));
          })(item, index, items, context);
        }
        return result;
      }
    });
  };

}).call(this);
