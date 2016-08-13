angular
  .module('chewyTracker')
  .controller('EditMealCtrl', [
    '$scope',
    '$state',
    '$stateParams',
    'meals',
    function($scope, $state, $stateParams, meals) {
      meal = meals.find($stateParams.id);

      $scope.meal = {
        name: meal.name,
        calories: meal.calories,
        eaten_at: new Date(meal.eaten_at)
      };

      $scope.save = function() {
        meals.update($stateParams.id, $scope.meal).then(function() {
          $scope.meal = {};

          $state.go('dashboard');
        });
      };
    }
  ]);
