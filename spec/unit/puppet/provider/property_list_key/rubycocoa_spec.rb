# NOTE: These tests require RubyCocoa and should be run on a Mac.
#       Because this provider is OS X-specific, the tests (and,
#       subsequently, the provider itself, will only run on OS X).

require 'puppet'
require 'puppet/type/property_list_key'
require 'fileutils'
require 'tempfile'

RSpec.configure do |config|
  config.mock_with :mocha
end

describe 'The rubycocoa provider for the property_list_key type' do
  let(:test_dir) { Dir.mktmpdir }
  let(:resource) do
    Puppet::Type::Property_list_key.new(
      {
        :name       => 'string_resource',
        :path       => File.join(test_dir, 'string.plist'),
        :key        => 'string',
        :value      => 'string value',
        :value_type => 'string'
      }
    )
  end
  let(:provider) { Puppet::Type.type(:property_list_key).provider(:rubycocoa).new(resource) }

  after :each do
    FileUtils.rm_rf(test_dir)
  end

  it 'exists? should return false if the plist file does not exist' do
    provider.exists?.should == false
  end

  it 'exists? should return true if the plist file exists' do
    provider.create
    provider.exists?.should == true
  end

  it 'should successfully destroy a resource' do
    provider.create
    provider.destroy
    provider.exists?.should == false
  end

  it 'should write a string value if a string value_type is passed' do
    provider.create
    provider.value.first.class.should == String
  end

  it 'should write a string value' do
    provider.create
    provider.value.first.should == 'string value'
  end

  it 'should set a string value with value=' do
    provider.create
    provider.value = 'foobar'
    provider.value.should == 'foobar'
  end

  it 'should write a boolean true value if a boolean value_type is passed' do
    resource[:value] = true
    resource[:value_type] = :boolean
    provider.create
    provider.value.class.should == TrueClass
  end

  it 'should set a boolean true value with value=' do
    resource[:value] = false
    resource[:value_type] = :boolean
    provider.create
    provider.value = true
    provider.value.should == true
  end

  it 'should write a boolean false value if a boolean value_type is passed' do
    resource[:value] = 'false'
    resource[:value_type] = :boolean
    provider.create
    provider.value.class.should == FalseClass
  end

  it 'should set a boolean false value with value=' do
    resource[:value] = true
    resource[:value_type] = :boolean
    provider.create
    provider.value = false
    provider.value.should == false
  end

  it 'should raise an error if an invalid boolean value is passed' do
    resource[:value] = 'bad'
    resource[:value_type] = :boolean
    expect { provider.create }.to raise_error Puppet::Error, \
      /Valid boolean values are 'true' or 'false', you specified 'bad'/
  end

  it 'should raise an error if an invalid boolean value is set' do
    resource[:value] = true
    resource[:value_type] = :boolean
    provider.create
    expect { provider.value = 'bad' }.to raise_error Puppet::Error, \
      /Valid boolean values are 'true' or 'false', you specified 'bad'/
  end

  it 'should write an integer value if an integer value_type is passed' do
    resource[:value] = '4'
    resource[:value_type] = :integer
    provider.create
    provider.value.class.should == Fixnum
  end

  it 'should set an integer value' do
    resource[:value] = '4'
    resource[:value_type] = :integer
    provider.create
    provider.value.should == 4
  end

  it 'should set an integer value with value=' do
    resource[:value] = '4'
    resource[:value_type] = :integer
    provider.create
    provider.value = '8'
    provider.value.should == 8
  end

  it 'should write a real value if an integer value_type is passed' do
    resource[:value] = '4'
    resource[:value_type] = :real
    provider.create
    provider.value.class.should == Float
  end

  it 'should write a real value if a float value_type is passed' do
    resource[:value] = '4.0'
    resource[:value_type] = :real
    provider.create
    provider.value.class.should == Float
  end

  it 'should set a real value' do
    resource[:value] = '4'
    resource[:value_type] = :real
    provider.create
    provider.value.should == 4.0
  end

  it 'should set a float value with value=' do
    resource[:value] = '4.0'
    resource[:value_type] = :real
    provider.create
    provider.value = '8.0'
    provider.value.should == 8.0
  end

  it 'should write an array value if an array value_type is passed' do
    resource[:value] = ['array', 'of', 'values']
    resource[:value_type] = :array
    provider.create
    provider.value.class.should == Array
  end

  it 'should set an array value' do
    resource[:value] = ['array', 'of', 'values']
    resource[:value_type] = :array
    provider.create
    provider.value.should == ['array', 'of', 'values']
  end

  it 'should set an array value with value=' do
    resource[:value] = ['array', 'of', 'values']
    resource[:value_type] = :array
    provider.create
    provider.value = ['new', 'array', 'of', 'values']
    provider.value.should == ['new', 'array', 'of', 'values']
  end

  it 'should write a hash value if a hash value_type is passed' do
    resource[:value] = { 'hash' => 'value' }
    resource[:value_type] = :hash
    provider.create
    provider.value.class.should == Hash
  end

  it 'should set a hash value' do
    resource[:value] = { 'hash' => 'value' }
    resource[:value_type] = :hash
    provider.create
    provider.value.should == { 'hash' => 'value' }
  end

  it 'should set a hash value with value=' do
    resource[:value] = { 'hash' => 'value' }
    resource[:value_type] = :hash
    provider.create
    provider.value = { 'another' => 'hash_value' }
    provider.value.should == { 'another' => 'hash_value' }
  end

  it 'insync? on the value type should return true if a string "is" value matches the "should" value' do
    resource[:value] = ['string value']
    provider.create
    resource.property(:value).insync?('string value').should be_true
  end

  it 'insync? on the value type should return false if a string "is" value does not match the "should" value' do
    resource[:value] = ['string value']
    provider.create
    resource.property(:value).insync?('bad value').should be_false
  end

  it 'insync? on the value type should return true if an array "is" value matches the "should" value' do
    resource[:value] = ['an', 'array', 'value']
    resource[:value_type] = :array
    provider.create
    resource.property(:value).insync?(['an', 'array', 'value']).should be_true
  end

  it 'insync? on the value type should return false if an array "is" value does not match the "should" value' do
    resource[:value] = ['an', 'array', 'value']
    resource[:value_type] = :array
    provider.create
    resource.property(:value).insync?(['bad', 'array']).should be_false
  end

  # It's important to note that in the boolean insync? tests, all values
  # coming from the Puppet DSL come in as STRING values - so setting
  # the value with resource[:value] = <value> should ALWAYS contain a
  # string value or the test doesn't accurately test the model.
  it 'insync? on the value type should return true if a boolean "is" value matches the "should" value' do
    resource[:value] = ['true']
    resource[:value_type] = :boolean
    provider.create
    resource.property(:value).insync?(true).should be_true
  end

  it 'insync? on the value type should return false if a boolean "is" value does not match the "should" value' do
    resource[:value] = ['true']
    resource[:value_type] = :boolean
    provider.create
    resource.property(:value).insync?(false).should be_false
  end

  it 'insync? on the value type should return true if a hash "is" value matches the "should" value' do
    resource[:value] = [{ 'hash' => 'value' }]
    resource[:value_type] = :hash
    provider.create
    resource.property(:value).insync?({ 'hash' => 'value' }).should be_true
  end

  it 'insync? on the value type should return false if a hash "is" value does not match the "should" value' do
    resource[:value] = [{ 'hash' => 'value' }]
    resource[:value_type] = :hash
    provider.create
    resource.property(:value).insync?({'bad' => 'hash'}).should be_false
  end

  # It's important to note that in the integer insync? tests, all values
  # coming from the Puppet DSL come in as STRING values - so setting
  # the value with resource[:value] = <value> should ALWAYS contain a
  # string value or the test doesn't accurately test the model.
  it 'insync? on the value type should return true if an integer "is" value matches the "should" value' do
    resource[:value] = ['1']
    resource[:value_type] = :integer
    provider.create
    resource.property(:value).insync?(1).should be_true
  end

  it 'insync? on the value type should return false if an integer "is" value does not match the "should" value' do
    resource[:value] = ['11']
    resource[:value_type] = :integer
    provider.create
    resource.property(:value).insync?(33).should be_false
  end
end

