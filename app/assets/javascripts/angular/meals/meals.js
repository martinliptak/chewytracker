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
      return $http.post('/api/v1/meals', { token: sessions.token, meal: meal });
    }

    function update(id, meal) {
      return $http.patch('/api/v1/meals/' + id, { token: sessions.token, meal: meal });
    }

    return m;
  }]);
