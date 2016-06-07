yellow.controller('episodeController', function ($interval, $filter, $http, teal, $scope, $location, $resource, $uibModal, $route, $log) {

  // program class
  var Episode = $resource( teal + '/episodes/:id',
   {id:'@id'});
  var Track = $resource( teal + '/episodes/:id/tracks/:track_id',
   {id:'@id', track_id:'@track_id'});

  // We can retrieve a collection from the server
  $scope.episode = Episode.get({id: $route.current.params.id});
  $scope.tracks = Track.query({id: $route.current.params.id});
  $scope.newTrack = new Track();
  $scope.endRecordingText = 'End recording';

  // interval to increment the timer
  var timerinterval = $interval( $scope.timer, 1000);

  $scope.timer = function(){
    var start = $scope.episode.start_time;
    var end = $scope.episode.end_time;
    if (start && end)  {
      $interval.cancel(timerinterval);
      return ""
    } else if (start && !end) {
      return $filter('date')(new Date() - Date.parse(start) + ($scope.episode.delay * 1000), 'H:mm:ss', "+0000");
    } else {
      return "0:00:00";
    }
  }


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

  $scope.startEpisode = function(){
    // $scope.episode.start_time = moment.utc();
    // $scope.episode.$save({id: $route.current.params.id}, function () {
    //   $scope.episode = Episode.get({id: $route.current.params.id});
    // });
    $http.post( teal + "/episodes/" + $route.current.params.id + "/start", {}).success(function(response) {
        $scope.episode = Episode.get({id: $route.current.params.id}) 
    });
  };

  $scope.endEpisode = function(){
    $interval.cancel(timerinterval);
    $scope.endRecordingText = 'Ending...';
    $http.post( teal + "/episodes/" + $route.current.params.id + "/stop", {}).success(function(response) {
        $scope.episode = Episode.get({id: $route.current.params.id}) 
    });
  };

  $scope.submit = function($files, $event, $flow){
    $flow.opts.target = teal + "/episodes/" + $route.current.params.id + "/upload";
    $flow.opts.chunkSize = 5*1024*1024;
		$flow.opts.withCredentials = true;
		$flow.upload();
	};


  $scope.edittrack = function(track){
    track.$save({id: $route.current.params.id, track_id: track.id}, function () {
      track.editing = false;
    });
  };

  $scope.saveNewTrack = function(){
    $scope.newTrack.$save({id: $route.current.params.id}, function () {
      $scope.tracks = Track.query({id: $route.current.params.id});
      $scope.newTrack = new Track();
    });
  };

  $scope.logTrack = function(track){
    // track.log_time = moment.utc();
    // track.$save({id: $route.current.params.id, track_id: track.id}, function () {
    //   $scope.tracks = Track.query({id: $route.current.params.id});
    // });
    $http.post( teal + "/episodes/" + $route.current.params.id + "/tracks/" + track.id + "/log", {}).success(function(response) {
      $scope.tracks = Track.query({id: $route.current.params.id});
    });
  };

  $scope.deleteTrack = function (track) {
    track.$remove({id: $route.current.params.id, track_id: track.id},function () {
      track.editing = false;
      $scope.tracks = Track.query({id: $route.current.params.id});
    });
  };
  $scope.getTimeDiff = function(track){
    var epstart = moment($scope.episode.start_time);
    var tracklog = moment(track.log_time);
    return tracklog.diff(epstart, 'minutes')
  };

  $scope.suggestSongs = function(song){
    var split = view.split("-");
    var title = split[0];
    var artist = split[1];
    $http({
      withCredentials: false,
      method: 'GET',
      url: 'https://musicbrainz.org/ws/2/recording?query=%22'+title+'%22%20AND%20artist:%22'+artist+'%22&fmt=json'
    }).then(function successCallback(response) {
        // this callback will be called asynchronously
        // when the response is available
        return response.data.recordings
    }, function errorCallback(response) {
        // called asynchronously if an error occurs
        // or server returns response with an error status.
    });
  };
});


