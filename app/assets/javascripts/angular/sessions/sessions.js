angular
  .module('chewyTracker')
  .factory('sessions', ['$http', '$q', function($http, $q) {
    var session = {
      logIn: logIn,
      logOut: logOut,
      isLoggedIn: isLoggedIn,
      token: null,
      currentUser: null
    }

    function getApiToken(credentials) {
      return $http.post('/api/v1/access_tokens', { credentials: credentials });
    }

    function getUser(userId) {
      return $http.get('/api/v1/users/' + userId, { params: { token: session.token } });
    }

    function logIn(credentials) {
      return $q(function (resolve, reject) {
        getApiToken(credentials)
          .then(function (response) {
            session.token = response.data.name;

            getUser(response.data.user_id)
              .then(function(response) {
                session.currentUser = response.data;

                resolve();
              })
              .catch(function() {
                reject();
              });
          })
          .catch(function() {
            reject();
          });
      });
    }

    function logOut() {
      session.currentUser = null;
    }

    function isLoggedIn() {
      return !!session.currentUser;
    }

    return session;
  }]);
