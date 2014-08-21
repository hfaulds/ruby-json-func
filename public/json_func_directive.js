angular.module('jsonFunc', [])
  .directive('jsonFuncBuilder', function() {
    return {
      restrict: 'E',
      templateUrl: 'func_template.html',
      scope: {
        valid_functions: '=',
        column: '@',
      },
      scope: function($scope) {
        $scope.json_from_hash = function(func) {
          if(func && func.args) {
            var arg_values = _.map(func.args, function(arg) {
              if(arg.name.split('_')[0] == 'hash') {
                return _.object(_.compact(arg.keys), arg.values);
              } else if(arg.name.split('_')[0] == 'list') {
                return ['list'].concat(_.compact(arg.values));
              } else {
                return arg.value;
              }
            })
            var json = [func.name].concat(arg_values);
            return JSON.stringify(json);
          }
        };
      },
      link: function($scope) {
        $scope.valid_functions = angular.copy($scope.valid_functions);

        if($scope.column.persisted_func) {
          var arr = JSON.parse($scope.column.persisted_func);
          var func = _.findWhere($scope.valid_functions, {name: arr[0]});

          _.each(_.rest(arr, 1), function(arg, i) {
            if(typeof arg === 'object') {
              func.args[i].keys = _.keys(arg);
              func.args[i].values = _.values(arg);
            } else if(arg[0] === 'list') {
              func.args[i].values = arg;
            } else {
              func.args[i].value = arg;
            }
          });

          $scope.selected_func = func;
          $scope.$watch('selected_func', function() {
            $scope.column.selected_func = $scope.json_from_hash($scope.selected_func);
          }, true);
        };
      },
    };
  })
