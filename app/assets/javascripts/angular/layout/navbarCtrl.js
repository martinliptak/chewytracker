angular
  .module('chewyTracker')
  .controller('NavbarCtrl', [
    '$scope',
    '$state',
    'sessions',
    function($scope, $state, sessions) {
      $scope.logOut = function() {
        sessions.logOut();

        $state.go('login');
      };

      $scope.$on('logged-in', function() {
        $scope.isLoggedIn = sessions.isLoggedIn();
        $scope.currentUser = sessions.currentUser;
      });
    }
  ]);
