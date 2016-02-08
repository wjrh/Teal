yellow.controller('programsController', function (teal, $scope, $uibModal, $resource, $log) {

  var Program = $resource( teal + '/programs/:shortname',
   {shortname:'@shortname'});

  $scope.programs = Program.query();

$scope.newProgram = function () {
    var newProgram = new Program();
    var modalInstance = $uibModal.open({
      animation: $scope.animationsEnabled,
      templateUrl: 'programModal.html',
      controller: 'programModalController',
      resolve: {
        program: function () {
          return newProgram;
        } 
      }
    });


    modalInstance.result.then(function () {
      $scope.programs = Program.query();
    }, function () {
      $log.info('Program Modal dismissed at: ' + new Date());
    }
  )};


});
