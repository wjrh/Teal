// script.js

// create the module and name it yellow
var yellow = angular.module('yellow', ['ngRoute','ngResource','ui.bootstrap','flow'])
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

      }).when('/',{
        templateUrl: 'login.html',
        controller: 'loginController'

      }).when('/loggedin', {
        redirectTo: '/programs'

      }).otherwise({redirectTo: '/'});

    $locationProvider.html5Mode(true);
}]);

yellow.config(function ($httpProvider) {
	  $httpProvider.defaults.withCredentials = true;
});

yellow.config(['$resourceProvider', function ($resourceProvider) {
  $resourceProvider.defaults.stripTrailingSlashes = false;
}]);

yellow.constant('teal', 'https://api.teal.cool');


yellow.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;
            
            element.bind('change', function(){
                scope.$apply(function(){
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
}]);

yellow.service('fileUpload', ['$http', function ($http) {
    this.uploadFileToUrl = function(file, uploadUrl){
        var fd = new FormData();
        fd.append('file', file);
        $http.post(uploadUrl, fd, {
            transformRequest: angular.identity,
            headers: {'Content-Type': undefined}
        })
        .success(function(){
        })
        .error(function(){
        });
    }
}]);
