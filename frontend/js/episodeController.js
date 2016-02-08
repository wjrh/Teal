yellow.controller('episodeController', function (teal, $scope, $location, $resource, $uibModal, $route, $log) {

  // program class
  var Episode = $resource( teal + '/episodes/:id',
   {id:'@id'});

  // We can retrieve a collection from the server
  $scope.episode = Episode.get({id: $route.current.params.id});


  $scope.editEpisode = function (episode) {
    var modalInstance = $uibModal.open({
      animation: $scope.animationsEnabled,
      templateUrl: 'episodeModal.html',
      controller: 'episodeModalController',
      resolve: {
        episode: function () {
          return episode;
        }
      }
    });


    modalInstance.result.then(function () {
      $scope.episode = Episode.get({id: $route.current.params.id})
    }, function () {
      $log.info('Episode Modal dismissed at: ' + new Date());
    })
  
  };


});