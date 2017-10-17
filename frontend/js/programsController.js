yellow.controller('programsController', function (teal, $http, $scope, $uibModal, $resource, $log, $location) {

  var Program = $resource( teal + '/programs/:shortname',
   {shortname:'@shortname'});

  $scope.programs = Program.query();
  $scope.logOut = function() {
    $http.get(teal + "/logout", {}).then(
    function () {
      $location.path('/login');
    },
    function () {
      $location.path('/login');
    }
    );
  };
  
    modalInstance.result.then(function () {
      $scope.programs = Program.query();
    }, function () {
      $log.info('Program Modal dismissed at: ' + new Date());
    }
  )};


});
