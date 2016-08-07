angular
  .module('chewyTracker', ['ui.router', 'templates'])
  .config([
    '$stateProvider',
    '$urlRouterProvider',
    function($stateProvider, $urlRouterProvider) {

      $stateProvider
        .state('dashboard', {
          url: '',
          templateUrl: 'angular/dashboard/_dashboard.html',
          controller: 'DashboardCtrl'
        });

      $urlRouterProvider.otherwise('');
    }
  ]);
