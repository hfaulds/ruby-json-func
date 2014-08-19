angular.module('jsonFunc', [])
  .directive('jsonFuncBuilder', function() {
    return {
      restrict: 'E',
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
        var nonRecurrsiveInitArgs = function(arr, func) {
          func.name = arr[0];
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
          return func;
        };

        $scope.column.valid_functions = angular.copy($scope.valid_functions);
        if($scope.column.persisted_func) {
          $scope.column.selected_func = nonRecurrsiveInitArgs($scope.column.persisted_func,
            _.findWhere($scope.column.valid_functions, {name: $scope.column.persisted_func[0]})
          );
        }
      },
      templateUrl: 'func_template.html'
    };
  })
