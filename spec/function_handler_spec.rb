require 'function_handler'

describe FunctionHandler do
  class TestHandler
    extend FunctionHandler

    describe :a_function, {
      description: 'description',
      args: [
        {
          name: 'an_argument',
          description: 'description',
          template: 'a_template.html'
        },
        {
          name: 'a_second_argument',
          description: 'description',
          template: 'a_template.html'
        }
      ]
    }
    def a_function(an_argument, a_second_argument)

    end
  end

  describe '.method_descriptions' do
    it 'retuns the argument descriptions' do
      expect(TestHandler.method_descriptions).to eq([{
        name: 'a_function',
        description: 'description',
        args: [ {
          name: 'an_argument',
          description: 'description',
          template: 'a_template.html'
        }, {
          name: 'a_second_argument',
          description: 'description',
          template: 'a_template.html'
        }]}
      ])
    end
  end
end

