app = angular.module "exampleApp"

# x-editable wrapper for date picker
app.directive "editableDatepicker", [
  "editableDirectiveFactory", (editableDirectiveFactory) ->
    editableDirectiveFactory
      directiveName: "editableDatepicker"

      inputTpl: """
        <div class="input-prepend">
          <input type="text" ng-model="$data" datepicker-popup="MM/dd/yyyy" is-open="opened">
          <button type="button" class="btn btn-default" ng-click="open($event)">
            <i class="icon-calendar"></i>
          </button>
        </div>
      """

      init: ->
        @parent.init()

        @scope.opened = false

        @scope.open = ($event) =>
          $event.preventDefault()
          $event.stopPropagation()

          @scope.opened = true
]

app.directive "editableSelect2", [
  "editableDirectiveFactory", (editableDirectiveFactory) ->
    editableDirectiveFactory
      directiveName: "editableSelect2"

      inputTpl: """
        <input type="hidden" ng-model="$data" />
      """
]

class ShowCtrl extends BaseCtrl

  @register app, "users.ShowCtrl"
  @inject "$scope", "$location", "select2Options", "exampleGrid", "sampleData", "user"

  initialize: ->
    @expose @$scope, "user", "update", "delete"

    # generate the sample data
    sampleData = @sampleData.generate(100)

    # initialize the grid with generated data
    @$scope.gridOptions = @exampleGrid
      data: sampleData
      shrinkToFit: true
      multiselect: false
      actionPopup: false

    @user.tags ?= ["user", "moderator"]

    # options for the parent user select
    @$scope.parentSelect2Options = @select2Options({
      ajax: url: "/api/users"

      # formatters for result and selection
      formatResult: (user) -> "#{user.name} - #{user.info.email}"
      formatSelection: (user) -> "#{user.name} - #{user.info.email}"
    })

    @$scope.roleSelect2Options =
      "multiple": true
      "simple_tags": true
      "tags": ["admin", "user", "guest", "moderator"]

    @user.notificationType ?= ""

    @$scope.notificationTypes = [
      { id: "", text: "None" }
      { id: "email", text: "Email" }
      { id: "fax", text: "Fax" }
    ]

  update: (user) ->
    user.$update()

  delete: (user) ->
    promise = user.delete().$promise
    promise.then => @$location.path("/examples/users")
