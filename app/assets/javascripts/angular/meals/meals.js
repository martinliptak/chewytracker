angular
  .module('chewyTracker')
  .factory('meals', ['$http', 'sessions', function($http, sessions) {
    var m = {
      load: load,
      find: find,
      create: create,
      update: update,
      meals: []
    };

    function load() {
      $http
        .get('/api/v1/meals', { params: { token: sessions.token } })
        .then(function(response) {
          angular.copy(response.data, m.meals);
        });
    }

    function find(id) {
      return m.meals.find(function(meal) {
        return meal.id == id
      });
    }

    function create(meal) {
      // TODO: Create request
    }

    function update(id, meal) {
      // TODO: Update request
    }

    return m;
  }]);
