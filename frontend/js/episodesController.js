yellow.controller('episodesController', function (teal, $scope, $resource, $uibModal, $route, $log) {

  var Program = $resource( teal + '/programs/:shortname',
   {shortname:'@shortname'}
  );

  var Episode = $resource( teal + '/episodes/:id', {id:'@id'}, {'save': {method:'POST', params:{shortname:$route.current.params.shortname}}});


  // We can retrieve a collection from the server
  $scope.program = Program.get({shortname: $route.current.params.shortname});

  $scope.editProgram = function (program) {
    var modalInstance = $uibModal.open({
      animation: $scope.animationsEnabled,
      templateUrl: 'programModal.html',
      controller: 'programModalController',
      resolve: {
        program: function () {
          return program;
        }
      }
    });

    modalInstance.result.then(function () {
      $scope.program = Program.get({shortname: $route.current.params.shortname});
    }, function () {
      $log.info('Program Modal dismissed at: ' + new Date());
    })
  
  };


  $scope.newEpisode = function () {
    var newEpisode = new Episode();
    newEpisode.pubdate = new Date().toISOString();
    var modalInstance = $uibModal.open({
      animation: $scope.anismationsEnabled,
      templateUrl: 'episodeModal.html',
      controller: 'episodeModalController',
      resolve: {
        episode: function () {
          return newEpisode;
        } 
      }
    });


    modalInstance.result.then(function () {
      $scope.program = Program.get({shortname: $route.current.params.shortname});
    }, function () {
      $log.info('Episode Modal dismissed at: ' + new Date());
    }
  )};


});
