class JobApplicationsController < ApplicationController

  def new
    @job_application = JobApplication.new
  end

  def create
    @job_application = JobApplication.new(params[:job_application])
    if @job_application.save
      JobApplicationMailer.application_notification(@job_application).deliver
      render 'show'
    else
      render 'new'
    end
  end

end
