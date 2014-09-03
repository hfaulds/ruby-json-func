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
    Function.from_array(initial_argument).execute(handler)
  end

  class Value
    attr_reader :val
    def initialize(val)
      @val = val
    end
    def execute(handler)
      val
    end
  end

  class Function
    attr_reader :func_name, :args
    def initialize(func_name, args=[])
      @func_name = func_name
      @args = args
    end

    def execute(handler)
      raise BadFunctionNameError.new(func_name) unless valid_function?(func_name, handler)
      values = args.map do |arg|
        arg.execute(handler)
      end

      if func_name == LIST_FUNCTION_NAME
        values
      else
        handler.send(func_name, *values)
      end
    end

    def valid_function?(func, handler)
      valid_functions(handler).include? func
    end

    def valid_functions(handler)
      (
        handler.public_methods - Object.new.public_methods + [LIST_FUNCTION_NAME]
      ).map(&:to_s)
    end

    def self.from_array(array)
      raise ZeroFunctionsError.new if array.size == 0
      func_name = array.first
      args = parse_args(array[1..-1])
      new(func_name, args)
    end

    def self.parse_args(args)
      args.map do |arg|
        parse_arg(arg)
      end
    end

    def self.parse_arg(arg)
      case arg
      when Array
        Function.from_array(arg)
      else
        Value.new(arg)
      end
    end
  end
end
