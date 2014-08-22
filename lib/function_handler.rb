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
