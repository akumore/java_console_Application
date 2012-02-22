class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "Rails.env=#{Rails.env} #{message.to} #{message.subject}"
    message.to = `git config user.email`.chomp
  end
end