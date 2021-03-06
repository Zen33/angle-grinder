describe "module: angleGrinder.forms", ->

  describe "directive: agDatepicker", ->

    beforeEach module "angleGrinder.forms"

    $scope = null
    element = null

    describe "use localDate date type (that is used by default)", ->
      beforeEach inject ($rootScope, $compile) ->
        $scope = $rootScope.$new()
        $scope.user = birthday: "1990-03-01"

        template = """
          <ag-datepicker ng-model="user.birthday"
                   name="birthday" >
          </ag-datepicker>
        """
        element = $compile(template)($scope)
        $rootScope.$apply()

      it "displays the current value", ->
        expect(element.find("input").val()).to.eq("03/01/1990")

      it "saves date to model", inject ($timeout)->
        $timeout.flush()
        expect($scope.user.birthday).to.eq("1990-03-01")

    describe "use `date` date type", ->
      beforeEach inject ($rootScope, $compile) ->
        $scope = $rootScope.$new()
        $scope.user = birthday: "1990-03-01"

        template = """
          <ag-datepicker ng-model="user.birthday"
                   date-type="date"
                   name="birthday" >
          </ag-datepicker>
        """
        element = $compile(template)($scope)
        $rootScope.$apply()

      it "displays the current value", ->
        expect(element.find("input").val()).to.eq("03/01/1990")

      it "saves local date time to model", inject ($timeout)->
        $timeout.flush()
        expect($scope.user.birthday).to.eq("1990-03-01T00:00+00:00")

    describe "use `localDateTime` type", ->
      beforeEach inject ($rootScope, $compile, $timeout) ->
        $scope = $rootScope.$new()
        $scope.user = birthday: "1990-03-01"

        template = """
          <ag-datepicker ng-model="user.birthday"
                   date-type="localDateTime"
                   name="birthday" >
          </ag-datepicker>
        """
        element = $compile(template)($scope)
        $rootScope.$apply()

      it "displays the current value", ->
        expect(element.find("input").val()).to.eq("03/01/1990")

      it "saves local date time to model", inject ($timeout)->
        $timeout.flush()
        expect($scope.user.birthday).to.eq("1990-03-01T00:00")
