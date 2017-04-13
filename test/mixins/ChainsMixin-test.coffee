{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require.main.require 'lib'
{ co } = RC::Utils

describe 'ChainsMixin', ->
  describe 'include ChainsMixin', ->
    it 'should create new class with chains and instantiate', ->
      expect ->
        class Test extends RC::Module
        Test.initialize()
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @Module: Test
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        assert.instanceOf myInstance, Test::MyClass, 'Cannot instantiate class MyClass'
      .to.not.throw Error
    it 'should add chain `test` and call it', ->
      co ->
        spyTest = sinon.spy -> yield return
        class Test extends RC::Module
        Test.initialize()
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @Module: Test
          @chains ['test']
          @public test: Function,
            configurable: yes
            default: spyTest
        Test::MyClass.initialize()
        assert.include Test::MyClass[Symbol.for 'internalChains'], 'test'
        myInstance = Test::MyClass.new()
        spyTestChain = sinon.spy myInstance, 'callAsChain'
        yield myInstance.test()
        assert spyTest.called, "Test didn't called"
        assert spyTestChain.called, "callAsChain didn't called"
  ###
    it 'should add chain and initial, before, after and finally hooks, and call it', ->
      expect ->
        spyTest = sinon.spy ->
        spyInitial = sinon.spy ->
        spyBefore = sinon.spy ->
        spyAfter = sinon.spy ->
        spyFinally = sinon.spy ->
        spyError = sinon.spy ->
        class Test extends RC::Module
        Test.initialize()
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @Module: Test
          @chains [ 'test' ]
          @initialHook 'initialTest', only: [ 'test' ]
          @beforeHook 'beforeTest1', only: [ 'test' ]
          @beforeHook 'beforeTest2', only: [ 'test' ]
          @afterHook 'afterTest', only: [ 'test' ]
          @finallyHook 'finallyTest', only: [ 'test' ]
          @errorHook 'errorTest', only: [ 'test' ]
          @public test: Function,
            configurable: yes
            default: spyTest
          @public initialTest: Function,
            default: spyInitial
          @public beforeTest1: Function,
            default: spyBefore
          @public beforeTest2: Function,
            default: spyBefore
          @public afterTest: Function,
            default: spyAfter
          @public finallyTest: Function,
            default: spyFinally
          @public errorTest: Function,
            default: spyError
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        myInstance.test()
        assert spyInitial.calledBefore(spyBefore), "Test initial hook didn't called"
        assert spyBefore.calledBefore(spyTest), "Test before hook didn't called"
        assert spyBefore.calledTwice, "Test before hook didn't called twice"
        assert spyTest.called, "Test didn't called"
        assert spyAfter.calledAfter(spyTest), "Test after hook didn't called"
        assert spyFinally.calledAfter(spyAfter), "Test finally hook didn't called"
        assert not spyError.called, "Test error hook called"
      .to.not.throw Error
    it 'should add chain and hooks, and throw an error inside it', ->
      expect ->
        spyTest = sinon.spy -> throw new Error 'Fail!'
        spyInitial = sinon.spy ->
        spyBefore = sinon.spy ->
        spyAfter = sinon.spy ->
        spyFinally = sinon.spy ->
        spyError = sinon.spy ->
        class Test extends RC::Module
        Test.initialize()
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @Module: Test
          @chains [ 'test' ]
          @initialHook 'initialTest', only: [ 'test' ]
          @beforeHook 'beforeTest', only: [ 'test' ]
          @afterHook 'afterTest', only: [ 'test' ]
          @finallyHook 'finallyTest', only: [ 'test' ]
          @errorHook 'errorTest', only: [ 'test' ]
          @public test: Function,
            configurable: yes
            default: spyTest
          @public initialTest: Function,
            default: spyInitial
          @public beforeTest: Function,
            default: spyBefore
          @public afterTest: Function,
            default: spyAfter
          @public finallyTest: Function,
            default: spyFinally
          @public errorTest: Function,
            default: spyError
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        try myInstance.test()
        assert spyInitial.calledBefore(spyBefore), "Test initial hook didn't called"
        assert spyBefore.calledBefore(spyTest), "Test before hook didn't called"
        assert spyTest.called, "Test didn't called"
        assert not spyAfter.called, "Test after hook called"
        assert not spyFinally.called, "Test finally hook called"
        assert spyError.called, "Test error not hook called"
      .to.not.throw Error
    it 'should call hooks in proper order', ->
      expect ->
        spyTest = sinon.spy ->
        spyFirst = sinon.spy ->
        spySecond = sinon.spy ->
        spyThird = sinon.spy ->
        spyFourth = sinon.spy ->
        spyFifth = sinon.spy ->
        spyError = sinon.spy ->
        class Test extends RC::Module
        Test.initialize()
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include RC::ChainsMixin
          @Module: Test
          @chains [ 'test' ]
          @finallyHook 'fifthTest', only: [ 'test' ]
          @afterHook 'fourthTest', only: [ 'test' ]
          @beforeHook 'thirdTest', only: [ 'test' ]
          @initialHook 'firstTest', only: [ 'test' ]
          @initialHook 'secondTest', only: [ 'test' ]
          @errorHook 'errorTest', only: [ 'test' ]
          @public test: Function,
            configurable: yes
            default: spyTest
          @public firstTest: Function,
            default: spyFirst
          @public secondTest: Function,
            default: spySecond
          @public thirdTest: Function,
            default: spyThird
          @public fourthTest: Function,
            default: spyFourth
          @public fifthTest: Function,
            default: spyFifth
          @public errorTest: Function,
            default: spyError
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        try myInstance.test()
        assert spyFirst.calledBefore(spySecond), "Test first hook not called properly"
        assert spySecond.calledBefore(spyThird), "Test second hook not called properly"
        assert spyThird.calledBefore(spyTest), "Test third hook not called properly"
        assert spyTest.calledBefore(spyFourth), "Test not called properly"
        assert spyFourth.calledBefore(spyFifth), "Test fourth hook not called properly"
        assert spyFifth.called, "Test fifth hook not called properly"
        assert not spyError.called, "Test error hook called"
      .to.not.throw Error
  describe 'correct mixing in', ->
    it 'should call correctly support mixins', ->
      expect ->
        spyTest = sinon.spy ->
        spyBeforeTest = sinon.spy ->
        spyMixinInitialize = sinon.spy ->
        spyMyInitialize = sinon.spy ->
        class Test extends RC::Module
        Test.initialize()
        class Test::MyMixin extends RC::Mixin
          @inheritProtected()
          @Module: Test
          @public @static initialize: Function,
            configurable: yes
            default: (args...) ->
              spyMixinInitialize()
              @super args...
        Test::MyMixin.initialize()
        class Test::MyClass extends RC::CoreObject
          @inheritProtected()
          @include Test::MyMixin
          @include RC::ChainsMixin
          @Module: Test
          @chains [ 'test' ]
          @beforeHook 'beforeTest', only: [ 'test' ]
          @public test: Function,
            configurable: yes
            default: spyTest
          @public beforeTest: Function,
            default: spyBeforeTest
          @public @static initialize: Function,
            configurable: yes
            default: (args...) ->
              spyMyInitialize()
              @super args...
        Test::MyClass.initialize()
        myInstance = Test::MyClass.new()
        myInstance.test()
        assert spyMyInitialize.called, "MyClass initialize not called properly"
        assert spyMixinInitialize.called, "Mixin initialize not called properly"
        assert spyTest.called, "Test not called properly"
        assert spyBeforeTest.called, "Test before hook not called properly"
      .to.not.throw Error
  ###
