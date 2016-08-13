angular
  .module('chewyTracker', ['ui.router', 'templates'])
  .config([
    '$stateProvider',
    '$urlRouterProvider',
    function($stateProvider, $urlRouterProvider) {
      $stateProvider
        .state('dashboard', {
          url: '',
          templateUrl: 'angular/dashboard/_index.html',
          controller: 'DashboardCtrl'
        })
        .state('meals', {
          url: '/meals',
          template: '<div ui-view></div>',
          abstract: true
        })
        .state('meals.new', {
          url: '/new',
          templateUrl: 'angular/meals/_meal.html',
          controller: 'NewMealCtrl'
        })
        .state('meals.edit', {
          url: '/{id}/edit',
          templateUrl: 'angular/meals/_meal.html',
          controller: 'EditMealCtrl'
        }).state('login', {
          url: '/login',
          templateUrl: 'angular/sessions/_login.html',
          controller: 'LoginCtrl'
        });

      $urlRouterProvider.otherwise('');
    }
  ])
  .run(['$rootScope', '$state', 'sessions', function($rootScope, $state, sessions) {
    $rootScope.$on('$locationChangeSuccess', function() {
      if (!sessions.isLoggedIn()) {
        $state.go('login');
      }
    })
  }]);
