angular
  .module('chewyTracker')
  .factory('meals', [function() {
    var meals = [
      {id: 1, name: 'Dinner on Saturday', calories: 250, eatenAt: '06 Aug 18:00'},
      {id: 2, name: 'Lunch on Saturday', calories: 250, eatenAt: '06 Aug 12:00'},
      {id: 3, name: 'Breakfast on Saturday', calories: 250, eatenAt: '06 Aug 09:00'},
      {id: 4, name: 'Dinner on Friday', calories: 250, eatenAt: '06 Aug 18:00'},
      {id: 5, name: 'Lunch on Friday', calories: 250, eatenAt: '06 Aug 12:00'},
      {id: 6, name: 'Breakfast on Friday', calories: 250, eatenAt: '06 Aug 09:00'}
    ];

    return {
      create: function(meal) {
        meals.unshift(meal);
      },
      update: function(id, meal) {
        //TODO
      },
      meals: meals
    };
  }]);
