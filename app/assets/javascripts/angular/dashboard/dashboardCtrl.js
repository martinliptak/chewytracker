function isToday(date) {
  return (new Date().toDateString() == new Date(date).toDateString());
}

function totalCalories(meals) {
  return meals
    .filter(function(meal) {
      return isToday(meal.eaten_at);
    })
    .reduce(function(sum, meal) {
      return sum + meal.calories
    }, 0);
}

angular
  .module('chewyTracker')
  .controller('DashboardCtrl', [
    '$scope',
    'meals',
    'sessions',
    function($scope, meals, sessions) {
      $scope.meals = meals.meals;
      $scope.expectedCalories = sessions.currentUser.expected_calories;

      $scope.$watch('meals', function(meals) {
        $scope.totalCalories = totalCalories(meals);
        $scope.totalCaloriesExceeded = $scope.totalCalories - $scope.expectedCalories > 0;
      }, true);

      $scope.deleteMeal = function(id) {
        if (window.confirm('Really?')) {
          meals.destroy(id).then(function() {
            meals.load(); // :)
          });
        }
      };
    }
  ]);
