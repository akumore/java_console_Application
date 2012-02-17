class JobApplicationsController < ApplicationController

  respond_to :html, :js

  def new
    @job_application = JobApplication.new
    respond_with @job_application
  end

  def create
    @job_application = JobApplication.new(params[:job_application])
    if @job_application.save
      session[:job_application_id] = @job_application.id
      # TODO: send email to heidi rohner
      redirect_to job_application_path
    else
      render 'new'
    end
  end

  def show
    @job_application = JobApplication.find(session[:job_application_id])
    respond_with @job_application
  end
end
