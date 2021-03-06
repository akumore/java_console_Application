require 'spec_helper'

describe EmployeeObserver do

  # mongoid observers are singletons
  subject { EmployeeObserver.instance }

  let :real_estate do
    RealEstate.new :title => 'Test'
  end

  let :employee do
    Employee.new(firstname: 'Foo', lastname: 'Bar', phone: '123 456 78 90', email: 'foo.bar@foo.com', department: 'Foo Department', real_estates: [ real_estate ])
  end

  describe '#after_update' do
    it 'clears the cache' do
      RealEstateObserver.should_receive(:expire_cache_for)
      subject.after_update(employee)
    end
  end
end
