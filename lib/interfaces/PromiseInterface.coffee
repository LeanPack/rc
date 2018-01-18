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
    ANY
  } = Module::

  Module.defineInterface 'PromiseInterface', (BaseClass) ->
    class extends BaseClass
      @inheritProtected()

      @public @static @virtual all: Function,
        args: [Array] # iterable
        return: PromiseInterface

      @public @static @virtual reject: Function,
        args: [Error] # reason
        return: PromiseInterface

      @public @static @virtual resolve: Function,
        args: [ANY]
        return: PromiseInterface

      @public @static @virtual race: Function,
        args: [Array] # iterable
        return: PromiseInterface

      @public @virtual catch: Function,
        args: [Function] # onRejected
        return: PromiseInterface

      @public @virtual "then": Function,
        args: [Function, Function] # onFulfilled, onRejected
        return: PromiseInterface


      @initializeInterface()
