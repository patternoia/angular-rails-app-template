controllers = angular.module('controllers')
controllers.controller("IndexController", [ '$scope', '$routeParams', '$location', '$resource', 'flash',
  ($scope,$routeParams,$location,$resource,flash)->
    $scope.showAlert = true
    flash.success = "With flash preconfigured"
])
