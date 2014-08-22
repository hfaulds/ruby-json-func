require 'json'

class JsonFunc
  class ZeroFunctionsError < RuntimeError; end;
  class BadFunctionNameError < RuntimeError; end;
  attr_reader(:handler)

  class Function < Array; end;

  def initialize(handler)
    @handler = handler
  end

  def execute(json)
    initial_argument = JSON.parse(json)
    parse_arg(initial_argument)
  end

  def execute_fuction(hash)
    raise ZeroFunctionsError.new(hash.keys) if hash.size == 0
    func = hash.first
    raise BadFunctionNameError.new(func) unless valid_function?(func)
    args = hash[1..-1].map do |arg|
      parse_arg(arg)
    end
    return args if func == 'list'
    handler.send(func, *args)
  end

  def valid_function?(func)
    (handler.public_methods - Object.new.public_methods + ['list']).map(&:to_s).include? func
  end

  def parse_arg(arg)
    case arg
    when Array
      execute_fuction(arg)
    else
      arg
    end
  end

  module FunctionHandler
    def describe(function_name, description)
      @method_descriptions ||= {}
      @method_descriptions[function_name.to_s] = description
    end

    def method_descriptions
      @method_descriptions.map { |method_name, method_description|
        method_description.merge(name: method_name)
      }
    end
  end
end
