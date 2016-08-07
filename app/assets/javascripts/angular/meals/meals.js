angular
  .module('chewyTracker')
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
  }]);
