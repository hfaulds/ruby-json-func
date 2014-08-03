require 'json'

class JsonFunc
  class BadRootObject < RuntimeError; end;
  class MultipleFunctionsError < RuntimeError; end;
  class ZeroFunctionsError < RuntimeError; end;
  class BadFunctionNameError < RuntimeError; end;
  attr_reader(:handler)

  def initialize(handler)
    @handler = handler
  end

  def execute(json)
    initial_argument = JSON.parse(json)
    raise BadRootObject unless initial_argument.is_a? Hash
    execute_hash(initial_argument)
  end

  def execute_hash(hash)
    raise MultipleFunctionsError.new(hash.keys) if hash.size > 1
    raise ZeroFunctionsError.new(hash.keys) if hash.size == 0
    func = hash.keys.first
    raise BadFunctionNameError.new(func) unless valid_function?(func)
    arg = hash.values.first
    handler.send(func, *parse_arg(arg))
  end

  def valid_function?(func)
    (handler.public_methods - Object.new.public_methods).include? func
  end

  def parse_arg(arg)
    case arg
    when Hash
      execute_hash(arg)
    when Array
      arg
    else
      [arg]
    end
  end
end
