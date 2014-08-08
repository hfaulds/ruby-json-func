require 'sinatra'
require_relative 'lib/json_func'

class ExmpleHandler
  def acres_to_sq_feet(lookup_field)
  end

  def address(list_lookup_address_parts)
  end

  def publicly_viewable(lookup_status, list_str_statuses)
  end

  def show_address(lookup_field, hash_show_address)
  end

  def fetch_or_notify(lookup_status, hash_statuses, str_default)
  end
end

get '/' do
  executor = JsonFunc.new(ExmpleHandler.new)
  valid_functions = (executor.handler.public_methods - Object.new.public_methods).map { |func_name|
    method = executor.handler.method(func_name)
    {
      name: func_name,
      args: method.parameters.map { |arg|
        { name: arg[1] }
      }
    }
  }
  haml :index, locals: {
    valid_functions: valid_functions,
    raw_data_columns: [ 'A', 'B', 'C', 'D' ],
    target_columns: [{name: 1, },{name: 2},{name: 3},{name: 4},{name: 5},{name: 6}]
  }
end
