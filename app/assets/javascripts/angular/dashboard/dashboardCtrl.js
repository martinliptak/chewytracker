angular
  .module('chewyTracker')
  .controller('DashboardCtrl', [
    '$scope',
    'meals',
    function($scope, meals) {
      $scope.meals = meals.meals;

      $scope.addMeal = function() {
        $scope.meals.unshift({
          name: $scope.name,
          calories: $scope.calories,
          eatenAt: $scope.eatenAt
        });

        $scope.name = '';
        $scope.calories = '';
        $scope.eatenAt = '';
      };
    }
  ]);
