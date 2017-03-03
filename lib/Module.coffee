# _             = require 'lodash'
# joi           = require 'joi'
inflect       = require('i')()
# fs            = require 'fs'
# semver        = require 'semver'
# FoxxRouter    = require '@arangodb/foxx/router'


# FOLDERS       = [
#   'utils'
#   'mixins'
#   'models'
#   'controllers'
# ]

###
  ```
  ```
###


module.exports = (RC)->
  class RC::Module extends RC::CoreObject
    @inheritProtected()
    Utils:      null # must be defined as {} in child classes
    Constants:  null # must be defined as {} in child classes

    @public @static @virtual context: RC::Constants.ANY

    @public @static Module: RC::Class,
      get: -> @

    @public @static lookup: Function,
      args: [String]
      return: [RC::Class, RC::Constants.NILL]
      default: (fullname)->
        [section, name] = fullname.split ':'
        vsSection = inflect.camelize section
        vsName = inflect.camelize name
        @::["#{vsName}#{vsSection}"] ? null

    # @getClassesFor: (subfolder)->
    #   subfolderDir = fs.join @context.basePath, 'dist', subfolder
    #
    #   _files = _.chain fs.listTree subfolderDir
    #     .filter (i) -> fs.isFile fs.join subfolderDir, i
    #     .map (i) -> i.replace /\.js$/, ''
    #     .orderBy()
    #     .value()
    #   for _file in _files
    #     require fs.join subfolderDir, _file
    #   return

    # @initializeModules: ->
    #   if @context.manifest.dependencies?
    #     for own dependencyName, dependencyDefinition of @context.manifest.dependencies
    #       do ({name, version, required}=dependencyDefinition)=>
    #         required ?= no
    #         if required
    #           vModule = @context.dependencies[dependencyName]
    #           unless semver.satisfies vModule.context.manifest.version, version
    #             throw new Error "
    #               Dependent module #{vModule.name} not compatible.
    #               This module required version #{version} but #{vModule.name} version is #{vModule.context.manifest.version}.
    #             "
    #             return
    #         return
    #   return

    # @use: ->
    #   applicationRouter = new @::ApplicationRouter()
    #   router = FoxxRouter()
    #   Mapping = {}
    #   applicationRouter._routes.forEach (item)->
    #     controllerName = inflect.camelize inflect.underscore "#{item.controller.replace /[/]/g, '_'}Controller"
    #     Mapping[controllerName] ?= []
    #     Mapping[controllerName].push item.action unless _.includes Mapping[controllerName], item.action
    #   allSections = Object.keys Mapping
    #   availableSections = []
    #   availableSections.push
    #     id: 'system'
    #     module: @name
    #     actions: ['administrator']
    #   availableSections.push
    #     id: 'moderator'
    #     module: @name
    #     actions: allSections
    #   availableSections = availableSections.concat allSections.map (section)->
    #     id: section
    #     module: @name
    #     actions: Mapping[section]
    #   sectionSchema = joi.object
    #     id:       joi.string()
    #     module:   joi.string()
    #     actions:  joi.array().items(joi.string())
    #   sectionsSchemaForArray = joi.object
    #     availableSections: joi.array().items sectionSchema
    #   sectionsSchemaForItem = joi.object
    #     availableSection: sectionSchema
    #   router.get '/permitted_sections', (req, res)->
    #     res.send {availableSections}
    #   .response     sectionsSchemaForArray, "
    #     The permitted_sections.
    #   "
    #   .summary      "
    #     List of permitted_sections
    #   "
    #   .description  "
    #     Retrieves a list of permitted_sections.
    #   "
    #   router.get '/permitted_sections/:section', (req, res)=>
    #     switch req.pathParams.section
    #       when 'system'
    #         availableSection =
    #           id: 'system'
    #           module: @name
    #           actions: ['administrator']
    #       when 'moderator'
    #         availableSection =
    #           id: 'moderator'
    #           module: @name
    #           actions: allSections
    #       else
    #         availableSection =
    #           id: req.pathParams.section
    #           module: @name
    #           actions: Mapping[req.pathParams.section]
    #     res.send {availableSection}
    #   .response     sectionsSchemaForItem, "
    #     The permitted_section.
    #   "
    #   .summary      "
    #     Fetch the permitted_section
    #   "
    #   .description  "
    #     Retrieves the permitted_section by its key.
    #   "
    #   router.get '/version', (req, res)=>
    #     {version} = @context.manifest
    #     res.send {version}
    #   .response     joi.object(version: joi.string()), "
    #     Version of this service in semver format.
    #   "
    #   .summary      "
    #     Semver version of this service
    #   "
    #   .description  "
    #     Version may will be checked other services for still compatible
    #   "
    #
    #   @context.use router
    #
    #   applicationRouter

  # RC::Module.initialize()

  # RC::Module.initialize = ->
  #   # console.log '??????????????>>>> Module.initialize 111', @, @name, @context
  #   RC::Module.super('initialize') arguments
  #   global[@name] = @
  #   # console.log '??????????????>>>> Module.initialize 222', @, @name, @context
  #   # extend @, _.omit @context.manifest, ['name']
  #
  #   global['classes'] ?= {}
  #   global['classes'][@name] = @
  #   @initializeModules()
  #
  #   FOLDERS.forEach (subfolder)=>
  #     @getClassesFor subfolder
  #   require fs.join @context.basePath, 'dist', 'router'
  #   @

  return RC::Module.initialize()
