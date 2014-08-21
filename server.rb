require 'sinatra'
require_relative 'lib/json_func'
require_relative 'lib/function_handler'

class ExampleHandler
  extend FunctionHandler
  describe :acres_to_sq_feet, {
    description: 'Looks up a field, reads the value as acres and converts to sqft',
    arguments: {
      lookup_field: {
        description: 'A raw data field in acres',
        template: 'lookup.html'
      }
    }
  }
  def acres_to_sq_feet(lookup_field)
  end

  describe :address, {
    description: 'Look up an address based on a list of parts',
    arguments: {
      list_lookup_address_parts: {
        description: 'A list of raw field address parts in order',
        template: 'list_lookup.html'
      }
    }
  }
  def address(list_lookup_address_parts)
  end


  describe :publicly_viewable, {
    description: 'Takes a raw field for status and a list of publicly viewable statuses',
    arguments: {
      lookup_status: {
        description: 'Raw field for status of property',
        template: 'lookup.html'
      },
      list_str_statuses: {
        description: 'A list of statuses that are publicly viewable',
        template: 'list_str.html'
      }
    }
  }
  def publicly_viewable(lookup_status, list_str_statuses)
  end


  describe :show_address, {
    description: 'Takes a raw field for whether to show the address and a mapping of the possible raw values to either \'Y\' or \'G\'',
    arguments: {
      lookup_field: {
        description: 'Raw field for whether to show the address',
        template: 'lookup.html'
      },
      hash_show_address: {
        description: 'A mapping of possible raw values to \'Y\' or \'G\'',
        template: 'hash.html'
      }
    }
  }
  def show_address(lookup_field, hash_show_address)
  end

  describe :fetch_or_notify, {
    description: 'Takes a raw field for status, a mappings of raw statuses to our statuses and a default value to return if raw gives us a value not in the mapping',
    arguments: {
      lookup_status: {
        description: 'Raw field for status of property',
        template: 'lookup.html'
      },
      hash_statuses: {
        description: 'A mapping of raw statuses to our statuses',
        template: 'hash.html'
      },
      str_default: {
        description: 'The default status if we cant find the rest statuses in the mapping',
        template: 'str.html'
      }
    }
  }
  def fetch_or_notify(lookup_status, hash_statuses, str_default)
  end
end

get '/' do
  executor = JsonFunc.new(ExampleHandler.new)
  valid_functions = (executor.handler.public_methods - Object.public_instance_methods - FunctionHandler.public_instance_methods).map { |func_name|
    handler = executor.handler
    method = handler.method(func_name)
    method_description = handler.class.method_descriptions(func_name)
    {
      name: func_name,
      description: method_description[:description],
      args: method.parameters.map { |arg|
        { name: arg[1],
          description:  method_description[:arguments][arg[1]][:description],
          template:  method_description[:arguments][arg[1]][:template],
        }
      }
    }
  }
  haml :index, locals: {
    valid_functions: valid_functions,
    raw_data_columns: [ 'A', 'B', 'C', 'D' ],
    target_columns: [
      { name: 1, persisted_func: '["acres_to_sq_feet", "B"]' },
      { name: 2, persisted_func: '["fetch_or_notify", "B", {"FOO": "A"}, "A"]'},
      { name: 3},{name: 4},{name: 5},{name: 6}
    ]
  }
end

get '/func_template.html' do
  haml :func_template
end
