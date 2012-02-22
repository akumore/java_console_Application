if Rails.env.development?
  require 'development_mail_interceptor'
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end

if Rails.env.staging?
  require 'staging_mail_interceptor'
  ActionMailer::Base.register_interceptor(StagingMailInterceptor)
end