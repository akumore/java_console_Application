class Provider

  HOMEGATE = 'homegate'
  IMMOSCOUT = 'immoscout24'
  HOMECH = 'home_ch'
  IMMOSTREET = 'immostreet'
  ACLADO = 'aclado'

  def self.elements(provider)
    elements = %w(b li br)
    return elements unless [Provider::HOMEGATE, Provider::IMMOSCOUT].include?(provider)
    elements + %w(ul)
  end

end
