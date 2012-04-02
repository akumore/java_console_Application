class Cms::JobsController < Cms::SecuredController

  respond_to :html

  def index
    @jobs = Job.where(:locale => content_locale).order([:updated_at, :desc])
    respond_with @jobs
  end

  def new
    @job = Job.new(:locale => content_locale)
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

  def destroy
    job = Job.find(params[:id])
    job.destroy
    redirect_to cms_jobs_path
  end
end
