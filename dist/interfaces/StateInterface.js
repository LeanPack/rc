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
    var DictG, EventInterface, FuncG, HookedObjectInterface, MaybeG, NilT, StateInterface, StateInterfaceDefinition, StateMachineInterface, TransitionInterface;
    ({
      NilT,
      FuncG,
      DictG,
      MaybeG,
      EventInterface,
      TransitionInterface,
      StateMachineInterface,
      HookedObjectInterface,
      StateInterface: StateInterfaceDefinition
    } = Module.prototype);
    return StateInterface = (function() {
      class StateInterface extends HookedObjectInterface {};

      StateInterface.inheritProtected();

      StateInterface.module(Module);

      StateInterface.virtual({
        getEvents: FuncG([], DictG(String, EventInterface))
      });

      StateInterface.virtual({
        initial: Boolean
      });

      StateInterface.virtual({
        getEvent: FuncG(String, MaybeG(EventInterface))
      });

      StateInterface.virtual({
        defineTransition: FuncG([String, StateInterfaceDefinition, TransitionInterface, MaybeG(Object)], EventInterface)
      });

      StateInterface.virtual({
        removeTransition: FuncG(String, NilT)
      });

      StateInterface.virtual(StateInterface.async({
        doBeforeEnter: Function
      }));

      StateInterface.virtual(StateInterface.async({
        doEnter: Function
      }));

      StateInterface.virtual(StateInterface.async({
        doAfterEnter: Function
      }));

      StateInterface.virtual(StateInterface.async({
        doBeforeExit: Function
      }));

      StateInterface.virtual(StateInterface.async({
        doExit: Function
      }));

      StateInterface.virtual(StateInterface.async({
        doAfterExit: Function
      }));

      StateInterface.virtual(StateInterface.async({
        send: FuncG(String, NilT)
      }));

      StateInterface.initialize();

      return StateInterface;

    }).call(this);
  };

}).call(this);
