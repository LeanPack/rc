{ expect, assert } = require 'chai'
RC = require '../lib'
MetaObject = RC::MetaObject

describe 'MetaObject', ->
  describe '.new', ->
    it 'should create new meta-object', ->
      expect ->
        myInstance = RC::MetaObject.new()
        assert.instanceOf myInstance, RC::MetaObject, 'Cannot instantiate class MetaObject'
      .to.not.throw Error
  describe '#addMetaData', ->
    it 'should add key with data', ->
      expect ->
        myInstance = RC::MetaObject.new()
        myInstance.addMetaData 'testGroup', 'testProp', { 'test': 'test1' }
        assert.deepEqual myInstance.data.testGroup.testProp, { 'test': 'test1' }, 'Data not added'
      .to.not.throw Error
  describe '#addMetaData', ->
    it 'should remove key with data', ->
      expect ->
        myInstance = RC::MetaObject.new()
        myInstance.addMetaData 'testGroup', 'testProp', { 'test': 'test1' }
        myInstance.removeMetaData 'testGroup', 'testProp'
        assert.isUndefined myInstance.data.testGroup.testProp, 'Data not removed'
      .to.not.throw Error
  describe '#parent', ->
    it 'should create meta-data with parent', ->
      expect ->
        myParentInstance = RC::MetaObject.new()
        myInstance = RC::MetaObject.new myParentInstance
        assert.equal myInstance.parent, myParentInstance, 'Parent is incorrect'
      .to.not.throw Error
