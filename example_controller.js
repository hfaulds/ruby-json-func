angular.module('exampleApp', ['jsonFunc'])
  .controller('ExampleController', ['$scope', function($scope) {
    $scope.valid_functions = valid_functions;
    $scope.raw_data_columns = raw_data_columns;
    $scope.target_columns = target_columns;

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

    $scope.remove_blanks = function(values) {
      return _.compact(values).concat(['']);
    };

    $scope.remove_blanks_from_hash = function(arg) {
      var new_values = [];
      _.each(arg.keys, function(key, index) {
        if(_.identity(key)) {
          new_values.push(arg.values[index] || "");
        }
      });
      arg.keys = _.compact(arg.keys).concat(['']);
      arg.values = new_values;
    };
  }]);
