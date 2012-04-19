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
      flash[:success] = t("cms.employees.create.success")
    end

    respond_with @employee, :location => [:cms, :employees]
  end

  def edit
    @employee = Employee.find(params[:id])
    respond_with @employee
  end

  def update
    @employee = Employee.find(params[:id])

    if @employee.update_attributes(params[:employee])
      flash[:success] = t("cms.employees.update.success")
    end

    respond_with @employee, :location => [:cms, :employees]
  end

  def destroy
    @employee = Employee.find(params[:id])
    if @employee.destroy
      flash[:success] = t("cms.employees.destroy.success")
    end
    redirect_to [:cms, :employees]
  end
end
