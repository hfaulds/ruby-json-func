require 'sinatra'
require_relative 'lib/json_func'

class ExmpleHandler
  def func_with_one_arg(arr_1)

  end

  def func_with_two_args(str_1, str_2)

  end

  def func_with_var_args(*str_args)

  end
end

get '/' do
  executor = JsonFunc.new(ExmpleHandler.new)
  valid_functions = (executor.handler.public_methods - Object.new.public_methods).map { |func_name|
    method = executor.handler.method(func_name)
    {
      name: func_name,
      args: method.parameters.map { |arg|
        { name: arg[1], required: arg[0] == :req, vararg: arg[0] == :rest, value: '' }
      }
    }
  }
  haml :index, locals: {
    valid_functions: valid_functions,
    raw_data_columns: [ 'A', 'B', 'C', 'D' ],
    target_columns: [{name: 1, },{name: 2},{name: 3},{name: 4},{name: 5},{name: 6}]
  }
end
