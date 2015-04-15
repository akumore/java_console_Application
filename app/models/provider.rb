class Provider

  HOMEGATE = 'homegate'
  IMMOSCOUT = 'immoscout24'
  HOMECH = 'home_ch'
  IMMOSTREET = 'immostreet'
  ACLADO = 'aclado'

  def self.elements(provider)
    elements = %w(b li br)
    return elements unless [Provider::HOMEGATE, Provider::IMMOSCOUT].include?(provider)
    elements + %w(ul a)
  end

  def self.attributes(provider)
    attributes = {}
    return attributes unless [Provider::HOMEGATE, Provider::IMMOSCOUT].include?(provider)
    attributes.merge({ 'a' => ['href'] })
  end
end
