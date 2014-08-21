class MethodDescriptions
  def self.for(handler)
    (handler.public_methods - Object.public_instance_methods - FunctionHandler.public_instance_methods).map { |func_name|
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
  end
end
