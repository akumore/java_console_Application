class Cms::EmployeesController < Cms::SecuredController

  respond_to :html

  def index
    @employees = Employee.all.order([:lastname, :asc])
    respond_with @employees
  end

  def new
    @employee = Employee.new
    respond_with @employee
  end

  def create
    @employee = Employee.new(params[:employee])

    if @employee.save
      redirect_to edit_cms_employee_path(@employee)
    else
      render 'new'
    end
  end

  def edit
    @employee = Employee.find(params[:id])
    respond_with @employee
  end

  def update
    @employee = Employee.find(params[:id])

    if @employee.update_attributes(params[:employee])
      redirect_to edit_cms_employee_path(@employee)
    else
      render 'edit'
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.destroy
    redirect_to cms_employees_path
  end
end
