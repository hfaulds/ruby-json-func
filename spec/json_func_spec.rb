require 'spec_helper'

describe JsonFunc do
  let(:first_result) { double(:first_result) }
  let(:second_result) { double(:second_result) }

  let(:func_handler) { double(:func_handler) }
  subject { JsonFunc.new(func_handler) }

  before do
    func_handler.stub(public_methods: [:first, :second])
  end

  it 'executes functions with no arguments' do
    func_handler.stub(:first).and_return(first_result)
    expect(
      subject.execute('[ "first" ]')
    ).to eq(first_result)
  end

  it 'executes functions with multiple arguments' do
    func_handler.stub(:first).with('a', 'b').and_return(first_result)
    expect(
      subject.execute('[ "first", "a", "b" ]')
    ).to eq(first_result)
  end

  it 'executes functions with string arguments' do
    func_handler.stub(:first).with('a').and_return(first_result)
    expect(
      subject.execute('[ "first", "a" ]')
    ).to eq(first_result)
  end

  it 'executes functions with integer arguments' do
    func_handler.stub(:first).with(1).and_return(first_result)
    expect(
      subject.execute('[ "first", 1 ]')
    ).to eq(first_result)
  end

  it 'executes functions with boolean arguments' do
    func_handler.stub(:first).with(true).and_return(first_result)
    expect(
      subject.execute('[ "first", true ]')
    ).to eq(first_result)
  end

  it 'executes functions with hash arguments' do
    func_handler.stub(:first).with({'a' => 'b'}).and_return(first_result)
    func_handler.stub(:second).with(first_result).and_return(second_result)
    expect(
      subject.execute('[ "second", [ "first" , {"a" : "b"} ] ]')
    ).to eq(second_result)
  end

  it 'executes nested functions' do
    func_handler.stub(:first).with('a').and_return(first_result)
    func_handler.stub(:second).with(first_result).and_return(second_result)
    expect(
      subject.execute('[ "second", [ "first", "a" ] ]')
    ).to eq(second_result)
  end

  it 'does not expose private methods' do
    func_handler.stub(:third)
    expect {
      subject.execute('[ "third", "a" ]')
    }.to raise_error(JsonFunc::BadFunctionNameError, "third")
  end

  it 'does not expose methods from Object' do
    expect {
      subject.execute('[ "eql?", "a" ]')
    }.to raise_error(JsonFunc::BadFunctionNameError, "eql?")
  end

  it 'has a native list function' do
    func_handler.stub(:second).with([first_result, 'b']).and_return(second_result)
    func_handler.stub(:first).with('a').and_return(first_result)
    expect(
      subject.execute('[ "second", [ "list", [ "first", "a" ], "b" ] ]')
    ).to eq(second_result)
  end

  describe JsonFunc::FunctionHandler do
    class TestHandler
      extend JsonFunc::FunctionHandler

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
end
