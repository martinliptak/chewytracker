angular
  .module('chewyTracker')
  .controller('LoginCtrl', [
    '$rootScope',
    '$scope',
    '$state',
    'sessions',
    function($rootScope, $scope, $state, sessions) {
      $scope.credentials = {};
      $scope.logIn = function() {
        sessions
          .logIn($scope.credentials)
          .then(function() {
            $rootScope.$broadcast('logged-in');

            $state.go('dashboard');
          });
      };
    }
  ]);
