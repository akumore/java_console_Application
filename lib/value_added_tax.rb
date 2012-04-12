class ValueAddedTax
  attr_reader :netto

  def initialize(netto, tax)
    @netto = BigDecimal(netto)
    @tax = BigDecimal(tax)
  end

  def vat
    BigDecimal(netto) * @tax / BigDecimal(100)
  end
end