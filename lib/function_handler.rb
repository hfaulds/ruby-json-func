module FunctionHandler
  def method_descriptions(function_name)
    @method_descriptions ||= {}
    @method_descriptions[function_name]
  end
  def describe(function_name, description)
    @method_descriptions ||= {}
    @method_descriptions[function_name] = description
  end
end
