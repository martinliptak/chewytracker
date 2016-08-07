angular
  .module('chewyTracker')
  .controller('NewMealCtrl', [
    '$scope',
    '$state',
    'meals',
    function($scope, $state, meals) {
      $scope.newRecord = true;

      $scope.save = function() {
        meals.create($scope.meal);

        $scope.meal = {};

        $state.go('dashboard');
      };
    }
  ]);
