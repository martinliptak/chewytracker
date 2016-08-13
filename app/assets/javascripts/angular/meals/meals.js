angular
  .module('chewyTracker')
  .factory('meals', ['$http', 'sessions', function($http, sessions) {
    var m = {
      load: load,
      create: create,
      update: update,
      meals: []
    };

    function load() {
      $http
        .get('/api/v1/meals', { params: { token: sessions.token } })
        .then(function(response) {
          angular.copy(response.data.slice(0, 10), m.meals);
        });
    }

    function create(meal) {
      meals.unshift(meal);
    }

    function update(id, meal) {
      //TODO
    }

    return m;
  }]);
