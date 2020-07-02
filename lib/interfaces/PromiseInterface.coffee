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

# нужен, чтобы предоставить абстракцию промиса как такового. с виртуальными методами.
# по коду будут использоваться и иметь схожее с обычными промисами апи.
# инициализироваться они будут по разному (для ноды, в декоратор будет засовываться нативный промис, а для аранги, специальный объект, предоставляемый отдельным npm-пакетом, реализация которого будет строго синхронной для совместимости с платформой arangodb)

###
A Promise is in one of these states:

pending: initial state, not fulfilled or rejected.
fulfilled: meaning that the operation completed successfully.
rejected: meaning that the operation failed.
###

module.exports = (Module) ->
  {
    Interface
    FuncG
    MaybeG
    AnyT
    PromiseT
  } = Module::

  class PromiseInterface extends Interface
    @inheritProtected()
    @module Module

    @virtual catch: FuncG Function, PromiseT
    @virtual 'then': FuncG [Function, MaybeG Function], PromiseT
    @virtual finally: FuncG Function, PromiseT

    @virtual @static all: FuncG Array, PromiseT
    @virtual @static reject: FuncG Error, PromiseT
    @virtual @static resolve: FuncG AnyT, PromiseT
    @virtual @static race: FuncG Array, PromiseT


    @initialize()
