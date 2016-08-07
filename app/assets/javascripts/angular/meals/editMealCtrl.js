angular
  .module('chewyTracker')
  .controller('EditMealCtrl', [
    '$scope',
    '$state',
    '$stateParams',
    'meals',
    function($scope, $state, $stateParams, meals) {
      $scope.meal = meals.meals[$stateParams.id];

      $scope.save = function() {
        meals.update($stateParams.id, $scope.meal);

        $scope.meal = {};

        $state.go('dashboard');
      };
    }
  ]);
