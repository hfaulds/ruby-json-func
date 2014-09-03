require 'json'

class JsonFunc
  class ZeroFunctionsError < RuntimeError; end;
  class BadFunctionNameError < RuntimeError; end;
  attr_reader(:handler)

  LIST_FUNCTION_NAME = 'list'

  def initialize(handler)
    @handler = handler
  end

  def execute(json)
    initial_argument = JSON.parse(json)
    parse_arg(initial_argument)
  end

  def execute_fuction(arr)
    raise ZeroFunctionsError.new if arr.size == 0
    func = arr.first

    raise BadFunctionNameError.new(func) unless valid_function?(func)
    args = parse_args(arr[1..-1])

    return args if func == LIST_FUNCTION_NAME
    handler.send(func, *args)
  end

  def valid_function?(func)
    valid_functions.include? func
  end

  def valid_functions
    @valid_functions ||= (
      handler.public_methods - Object.new.public_methods + [LIST_FUNCTION_NAME]
    ).map(&:to_s)
  end

  def parse_args(args)
    args.map do |arg|
      parse_arg(arg)
    end
  end

  def parse_arg(arg)
    case arg
    when Array
      execute_fuction(arg)
    else
      arg
    end
  end
end
