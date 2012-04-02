class StagingMailInterceptor
  def self.delivering_email(message)
    message.subject = "TESTMAIL: #{message.subject}"
    message.to = %w(guelay.tatlici@alfred-mueller.ch christina.schweizer@alfred-mueller.ch)
    message.cc = %w(melinda.lini@screenconcept.ch immanuel.haeussermann@screenconcept.ch thomas.scholz@screenconcept.ch martin.wulff@screenconcept.ch)
  end
end