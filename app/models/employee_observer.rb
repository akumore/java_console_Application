class EmployeeObserver < Mongoid::Observer

  def after_update(employee)
    employee.real_estates.each do |re|
      RealEstateObserver.expire_cache_for(re)
    end
  end
end
