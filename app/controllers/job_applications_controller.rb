class JobApplicationsController < ApplicationController

  def new
    @job_application = JobApplication.new
  end

  def create
    @job_application = JobApplication.new(params[:job_application])
    if @job_application.save
      JobApplicationMailer.application_notification(@job_application).deliver
      log_event('Mitarbeiter', 'Anzahl Bewerbungen', @job_application.unsolicited? ? 'Initiativbewerbung' : @job_application.job.title)
      render 'show'
    else
      render 'new'
    end
  end

end
