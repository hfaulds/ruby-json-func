require 'spec_helper'

describe JsonFunc do
  let(:first_result) { double(:first_result) }
  let(:second_result) { double(:second_result) }

  let(:func_handler) { double(:func_handler) }
  subject { JsonFunc.new(func_handler) }

  before do
    func_handler.stub(public_methods: [:first, :second])
  end

  it 'executes functions with string arguments' do
    func_handler.stub(:first).with('a').and_return('first_result')
    expect(
      subject.execute('{ "first": "a" }')
    ).to eq('first_result')
  end

  it 'executes functions with integer arguments' do
    func_handler.stub(:first).with(1).and_return('first_result')
    expect(
      subject.execute('{ "first": 1 }')
    ).to eq('first_result')
  end

  it 'executes functions with boolean arguments' do
    func_handler.stub(:first).with(true).and_return('first_result')
    expect(
      subject.execute('{ "first": true }')
    ).to eq('first_result')
  end

  it 'executes functions with nil arguments' do
    func_handler.stub(:first).with(nil).and_return('first_result')
    expect(
      subject.execute('{ "first": null }')
    ).to eq('first_result')
  end

  it 'executes nested functions' do
    func_handler.stub(:first).with('a').and_return(first_result)
    func_handler.stub(:second).with(first_result).and_return(second_result)
    expect(
      subject.execute('{ "second": { "first" : "a" } }')
    ).to eq(second_result)
  end

  it 'executes functions with array arguments' do
    func_handler.stub(:first).with('a', 'b').and_return(first_result)
    func_handler.stub(:second).with(first_result).and_return(second_result)
    expect(
      subject.execute('{ "second": { "first" : ["a", "b"] } }')
    ).to eq(second_result)
  end

  it 'expects a hash as the root object in the json' do
    expect {
      subject.execute('["a", "b"]')
    }.to raise_error(JsonFunc::BadRootObject)
  end

  it 'exceptions if a hash has multiple keys' do
    expect {
      subject.execute('{ "func_one": "a", "func_two" : "b" }')
    }.to raise_error(JsonFunc::MultipleFunctionsError, '["func_one", "func_two"]')
  end

  it 'exceptions if a hash has no keys' do
    expect {
      subject.execute('{ "first": {} }')
    }.to raise_error(JsonFunc::ZeroFunctionsError)
  end

  it 'does not expose private methods' do
    func_handler.stub(:third)
    expect {
      subject.execute('{ "third": "a" }')
    }.to raise_error(JsonFunc::BadFunctionNameError, "third")
  end

  it 'does not expose methods from Object' do
    expect {
      subject.execute('{ "eql?": "a" }')
    }.to raise_error(JsonFunc::BadFunctionNameError, "eql?")
  end
end
