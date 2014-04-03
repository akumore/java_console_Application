class StagingMailInterceptor
  def self.delivering_email(message)
    message.subject = "TESTMAIL: #{message.subject}"
    message.to = %w(Janine.Wyss@alfred-mueller.ch)
    message.cc = %w(melinda.lini@screenconcept.ch flavio.pellanda@screenconcept.ch noelle.rosenberg@screenconcept.ch philipp.schilter@screenconcept.ch)
  end
end
