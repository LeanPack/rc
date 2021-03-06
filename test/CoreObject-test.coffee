{ expect, assert } = require 'chai'
sinon = require 'sinon'
RC = require '../lib'
{
  CoreObject
  Utils
} = RC::
{co} = Utils

describe 'CoreObject', ->
  describe 'constructor', ->
    it 'should be created (via `new` operator)', ->
      expect ->
        class Test extends RC
          @inheritProtected()
          @initialize()
        class SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @initialize()
        subTest = new SubTest()
      .to.not.throw Error
  describe '.new', ->
    it 'should be created (via `.new` method)', ->
      expect ->
        spyInit = sinon.spy -> @super arguments...
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @public init: Function,
            default: spyInit
        SubTest.initialize()
        SubTest.new()
        assert.isTrue spyInit.called, 'Init not called'
      .to.not.throw Error
  describe '.include', ->
    it 'should include mixin and call included method', ->
      co ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        Test.defineMixin RC::Mixin 'TestingMixin', (BaseClass) ->
          class extends BaseClass
            @inheritProtected()
            test: ->
            @initializeMixin()
        class SubTest extends CoreObject
          @inheritProtected()
          @include Test::TestingMixin
          @module Test
        SubTest.initialize()
        test = SubTest.new()
        test.test()
        yield return
  describe '.public', ->
    it 'should define and call public method', ->
      co ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @public test: Function,
            default: ->
        test = Test::SubTest.new()
        test.test()
        yield return
  describe '.private', ->
    it 'should define and call private method from public one', ->
      expect ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          ipmPrivateTest = @private _privateTest: Function,
            default: ->
          @public test: Function,
            default: ->
              @[ipmPrivateTest]()
        test = Test::SubTest.new()
        test.test()
      .to.not.throw Error
    it 'should define and cannot call private method directly', ->
      expect ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          ipmPrivateTest = @private _privateTest: Function,
            default: ->
        test = Test::SubTest.new()
        test._privateTest()
      .to.throw Error
  describe '.protected', ->
    it 'should define and call protected method from public one in derived class', ->
      expect ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @protected protectedTest: Function,
            default: -> 4
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @module Test
          ipmProtectedTest = @protected protectedTest: Function,
            default: -> @super(arguments...) + 1
          @public test: Function,
            default: ->
              @[ipmProtectedTest]()
        test = Test::SubSubTest.new()
        if test.test() isnt 5
          throw 'Wrong calculation!'
      .to.not.throw Error
    it 'should define and cannot call protected method directly', ->
      expect ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          ipmProtectedTest = @protected protectedTest: Function,
            default: ->
        test = Test::SubTest.new()
        test.protectedTest()
      .to.throw Error
    it 'should define and call protected method from derived class via `Symbol.for`', ->
      expect ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
          @protected protectedTest: Function,
            default: -> 4
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @module Test
          ipmProtectedTest = Symbol.for '~protectedTest'
          @public test: Function,
            default: ->
              @[ipmProtectedTest]()
        test = Test::SubSubTest.new()
        if test.test() isnt 4
          throw 'Wrong calculation!'
      .to.not.throw Error
  describe '.superclass', ->
    it 'should have superclass', ->
      co ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()

        class Test::SubTest extends CoreObject
          @inheritProtected()
          @module Test
        class Test::SubSubTest extends Test::SubTest
          @inheritProtected()
          @module Test
        assert Test::SubSubTest.superclass() is Test::SubTest, 'SubSubTest inheritance broken'
        assert Test::SubTest.superclass() is CoreObject, 'SubTest inheritance broken'
        yield return
  describe '.class', ->
    it 'should have class (static)', ->
      class Test extends RC
        @inheritProtected()
      Test.initialize()

      class Test::SubTest extends CoreObject
        @inheritProtected()
        @module Test
      Test::SubTest.initialize()
      expect Test::SubTest.class()
      .to.equal RC::Class
  describe '#class', ->
    it 'should have class (instance)', ->
      class Test extends RC
        @inheritProtected()
      Test.initialize()

      class Test::SubTest extends CoreObject
        @inheritProtected()
        @module Test
      Test::SubTest.initialize()
      expect Test::SubTest.new().class()
      .to.equal Test::SubTest
  describe 'long inheritance chain', ->
    it 'should keep all inherited functions', ->
      class Test extends RC
        @inheritProtected()
      Test.initialize()
      spyFirstTest = sinon.spy ->
      spyFourthTest = sinon.spy ->
      spyClassTest = sinon.spy ->
      Test.defineMixin RC::Mixin 'FirstMixin', (BaseClass) ->
        class extends BaseClass
          @inheritProtected()
          @public test: Function,
            default: (args...) ->
              @super args...
              spyFirstTest()
          @initializeMixin()
      Test.defineMixin RC::Mixin 'SecondMixin', (BaseClass) ->
        class extends BaseClass
          @inheritProtected()
          @initializeMixin()
      Test.defineMixin RC::Mixin 'ThirdMixin', (BaseClass) ->
        class extends BaseClass
          @inheritProtected()
          @initializeMixin()
      Test.defineMixin RC::Mixin 'FourthMixin', (BaseClass) ->
        class extends BaseClass
          @inheritProtected()
          @public test: Function,
            default: (args...) ->
              @super args...
              spyFourthTest()
          @initializeMixin()
      class MyClass extends RC::CoreObject
        @inheritProtected()
        @include Test::FirstMixin
        @include Test::SecondMixin
        @include Test::ThirdMixin
        @include Test::FourthMixin
        @module Test
        @public test: Function,
          default: (args...) ->
            @super args...
            spyClassTest()
      MyClass.initialize()
      test = MyClass.new()
      test.test()
      assert.isTrue spyFirstTest.called
      assert.isTrue spyFourthTest.calledAfter spyFirstTest
      assert.isTrue spyClassTest.calledAfter spyFourthTest
      assert.isTrue spyFirstTest.calledOnce
      assert.isTrue spyFourthTest.calledOnce
      assert.isTrue spyClassTest.calledOnce
  describe '.replicateObject', ->
    it 'should replicate specified class', ->
      co ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()
        class MyClass extends Test::CoreObject
          @inheritProtected()
          @module Test
        MyClass.initialize()
        instance = MyClass.new()
        replica = yield MyClass.replicateObject instance
        assert.equal replica.type, 'instance', 'Replica type isn`t `instance`'
        assert.equal replica.class, 'MyClass', 'Class name is different'
        yield return
  describe '.restoreObject', ->
    it 'should restore specified class by replica', ->
      co ->
        class Test extends RC
          @inheritProtected()
        Test.initialize()
        class MyClass extends Test::CoreObject
          @inheritProtected()
          @module Test
        MyClass.initialize()
        voRestored = yield Test.restoreObject Test, type: 'instance', class: 'MyClass'
        assert.equal voRestored.constructor, MyClass, 'Restored instance constructor is not `MyClass`'
        yield return
