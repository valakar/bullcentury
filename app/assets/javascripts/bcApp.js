(function() {
  testApp = angular.module('bcApp',['ngResource','ngRoute','ui.tinymce','ngImgCrop']);
  testApp.config(function($httpProvider) {
    var authToken;
    authToken = $("meta[name=\"csrf-token\"]").attr("content");
    return $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
  });

  // //Factory
  // testApp.factory('Products',['$resource', function($resource){
  //   return $resource('/api/products.json', {}, {
  //     query: {method: 'GET', isArray: true},
  //     create: {method: 'POST'}
  //   })
  // }]);

//  testApp.
//      config(['$routeProvider', function($routeProvider, $locationProvider) {
//      // Configure routes
//      $routeProvider.
//          when('/products', {templateUrl: '/templates/product-list.html',   controller: ProductController}).
////          when('/athletes/:id/new', {templateUrl: '/templates/product-new.html', controller: ProductNewCtrl}).
//          otherwise({redirectTo: '/home#index'});
//      // Enable 'HTML5 History API' mode for URLs.
//      // Note this requires URL Rewriting on the server-side. Leave this
//      // out to just use hash URLs `/#/athletes/1/edit`
//      $locationProvider.html5Mode(true);
//  }]);

  var module;
  $(document).on('page:load', function() {
    $('[ng-app]').each(function() {
      module = $(this).attr('ng-app');
      angular.bootstrap(this, [module]);
    });
  });
})();
