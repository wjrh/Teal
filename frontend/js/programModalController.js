yellow.controller('programModalController', function ($scope,$location, $uibModalInstance, program) {
  $scope.program = program;

  $scope.save = function () {
    $scope.program.$save(function () {
      $uibModalInstance.close();
    });
  };

  $scope.delete = function () {
    $scope.program.$remove(function () {
      $uibModalInstance.close();
      $location.path('/programs');
    });
  };

  $scope.cancel = function () {
    $uibModalInstance.dismiss('cancel');
  };
});