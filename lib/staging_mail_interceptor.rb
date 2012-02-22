class StagingMailInterceptor
  def self.delivering_email(message)
    message.subject = "AM Testmail: #{message.to}, #{message.subject}"
    message.to = 'thomas.scholz@screenconcept.ch'
    message.cc = %w(melinda.lini@screenconcept.ch immanuel.haeussermann@screenconcept.ch thomas.scholz@screenconcept.ch)
  end
end