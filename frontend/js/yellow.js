// script.js

// create the module and name it yellow
var yellow = angular.module('yellow', ['ngRoute','ngResource','ui.bootstrap'])
.config(['$routeProvider', '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider
      .when('/programs/:shortname', {
        templateUrl: 'episodes.html',
        controller: 'episodesController'

      }).when('/episodes/:id', {
        templateUrl: 'episode.html',
        controller: 'episodeController'

      }).when('/programs',{
        templateUrl: 'programs.html',
        controller: 'programsController'

      }).otherwise({redirectTo: '/programs'});;

    $locationProvider.html5Mode(true);
}]);

yellow.config(function ($httpProvider) {
	  $httpProvider.defaults.withCredentials = true;
});

yellow.config(['$resourceProvider', function ($resourceProvider) {
  $resourceProvider.defaults.stripTrailingSlashes = false;
}]);

yellow.constant('teal', 'http://renans-macbook-pro.local:9000');
