yellow.controller('episodeModalController', function ($scope, $location, $uibModalInstance,$log,  episode) {
  $scope.episode = episode;

  $scope.isFirstOpen = true;
  
  $scope.episode.name = $filter('date')(new Date(), 'MM-dd-yyyy');
  $scope.save = function () {
    $scope.episode.$save(function () {
      $uibModalInstance.close();
    });
  };

  $scope.delete = function () {
    $scope.episode.$remove(function () {
      $uibModalInstance.close();
      $location.path('/programs/' + $scope.episode.program_shortname);
    });
  };

  $scope.cancel = function () {
    $uibModalInstance.dismiss('cancel');
  };
});