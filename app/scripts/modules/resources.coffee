resources = angular.module("angleGrinder.resources", ["ngResource"])

resources.factory "Users", [
  "$resource", ($resource) ->
    Users = $resource "/api/users/:id", { id: "@id" },
      get: { method: "GET" },
      save: { method: "POST" },
      update: { method: "PUT" },
      delete: { method: "DELETE" }

    # The action methods on the class object or instance object can be invoked with the following parameters:
    # * HTTP GET "class" actions: Resource.action([parameters], [success], [error])
    # * non-GET "class" actions: Resource.action([parameters], postData, [success], [error])
    # * non-GET instance actions: instance.$action([parameters], [success], [error])
    angular.extend Users.prototype,
      # Retunrs true if the record is persisted (has an id)
      persisted: -> @id?

      # Backbone style save() that inserts or updated the record
      # based on the presence of an id.
      save: (options) ->
        method = if not @persisted() then "save" else "update"
        Users[method]({}, this, options.success, options.error)

      delete: (options) ->
        Users.delete({}, this, options.success, options.error)

    Users
]