describe "controller: usersDialog.ListCtrl", ->

  beforeEach module "angleGrinder.forms", ($provide) ->
    $provide.decorator "dialogCrudCtrlMixin", -> sinon.spy()

  beforeEach module "angleGrinder"

  $scope = null

  beforeEach inject ($rootScope, $controller) ->
    $scope = $rootScope.$new()

    $scope.usersGrid = {}

    $controller "usersDialog.ListCtrl",
      $scope: $scope
      Users: "Users"

  describe "$scope", ->
    it "assigns gridOptions", ->
      expect($scope.gridOptions).to.not.be.undefined

      expect($scope.gridOptions.colModel.length).to.equal 6
      expect($scope.gridOptions.colModel[0].name).to.equal "id"
      expect($scope.gridOptions.colModel[1].name).to.equal "login"
      expect($scope.gridOptions.colModel[2].name).to.equal "name"
      expect($scope.gridOptions.colModel[3].name).to.equal "allowance"
      expect($scope.gridOptions.colModel[4].name).to.equal "birthday"
      expect($scope.gridOptions.colModel[5].name).to.equal "paid"

  describe "mixin: `dialogCrudCtrlMixin`", ->

    it "is mixed", inject (dialogCrudCtrlMixin) ->
      expect(dialogCrudCtrlMixin.called).to.be.true

    it "is mixed with valid arguments", inject (dialogCrudCtrlMixin) ->
      expect(dialogCrudCtrlMixin.calledWith($scope)).to.be.true

      args = dialogCrudCtrlMixin.getCall(0).args[1]
      expect(args).to.have.property "Resource", "Users"
      expect(args).to.have.property "gridName", "usersGrid"
      expect(args).to.have.property "templateUrl", "templates/usersDialog/form.html"
