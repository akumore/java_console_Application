class Cms::JobsController < Cms::SecuredController

  respond_to :html

  def new
    @job = Job.new
    respond_with @job
  end

  def create
    @job = Job.new(params[:job])

    if @job.save
      redirect_to edit_cms_job_path(@job)
    else
      render 'new'
    end
  end

  def edit
    @job = Job.find(params[:id])
    respond_with @job
  end

  def update
    @job = Job.find(params[:id])

    if @job.update_attributes(params[:job])
      redirect_to edit_cms_job_path(@job)
    else
      render 'edit'
    end
  end
end
