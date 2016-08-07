angular
  .module('chewyTracker', [])
  .factory('meals', [function() {
    return {
      meals: [
        {name: 'Dinner on Saturday', calories: 250, eatenAt: '06 Aug 18:00'},
        {name: 'Lunch on Saturday', calories: 250, eatenAt: '06 Aug 12:00'},
        {name: 'Breakfast on Saturday', calories: 250, eatenAt: '06 Aug 09:00'},
        {name: 'Dinner on Friday', calories: 250, eatenAt: '06 Aug 18:00'},
        {name: 'Lunch on Friday', calories: 250, eatenAt: '06 Aug 12:00'},
        {name: 'Breakfast on Friday', calories: 250, eatenAt: '06 Aug 09:00'}
      ]
    };
  }])
  .controller('DashboardCtrl', [
    '$scope',
    'meals',
    function($scope, meals) {
      $scope.meals = meals.meals;
      console.log($scope.meals);

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
