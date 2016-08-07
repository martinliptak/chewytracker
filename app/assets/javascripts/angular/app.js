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
        });

      $urlRouterProvider.otherwise('');
    }
  ]);
